<?php

namespace dmstr\usuario\keycloak\controllers;

use Da\User\AuthClient\Keycloak;
use Da\User\Event\UserEvent;
use dmstr\usuario\keycloak\traits\AuditLogTrait;
use Yii;
use yii\authclient\ClientErrorResponseException;
use yii\authclient\OAuthToken;
use yii\base\InvalidArgumentException;
use yii\db\Query;
use yii\helpers\Url;
use yii\web\ServerErrorHttpException;

class SecurityController extends \Da\User\Controller\SecurityController
{
    use AuditLogTrait;

    public string $keycloakAuthClientId = 'keycloak';
    public bool $overrideAuthRedirect = true;
    public bool $skipLogoutConfirmation = true;
    public string $postLogoutRedirectUrl;

    /**
     * @inheritdoc
     */
    public function actions()
    {
        $actions = parent::actions();
        if ($this->overrideAuthRedirect) {
            // Original redirect view introduces some wierd js magic. We don't want that so we overload it.
            $actions['auth']['redirectView'] = dirname(__DIR__) . '/views/security/redirect.php';
        }
        return $actions;
    }

    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['access']['rules'][] = [
            'allow' => true,
            'actions' => ['front-channel-logout']
        ];
        return $behaviors;
    }

    /**
     * @ref https://openid.net/specs/openid-connect-frontchannel-1_0.html
     */
    public function actionFrontChannelLogout(string $sid, ?string $iss = null)
    {
        // [...] The response SHOULD include the Cache-Control HTTP response header field with a no-store value [...]
        $this->response->getHeaders()->set('Cache-Control', 'no-store');

        // Optional: Validate issuer if provided (RFC recommendation)
        if ($iss !== null) {
            try {
                /** @var Keycloak $client */
                $client = Yii::$app->authClientCollection->getClient($this->keycloakAuthClientId);
                $expectedIssuer = $client->getConfigParam('issuer');
                if ($expectedIssuer && $iss !== $expectedIssuer) {
                    $this->logError("Front-channel logout: issuer mismatch. Expected: {$expectedIssuer}, Got: {$iss}");
                    return '';
                }
            } catch (\Exception $e) {
                $this->logError("Front-channel logout: Could not validate issuer: " . $e->getMessage());
                return '';
            }
        }

        // Get the current session ID to check if it needs to be destroyed
        $currentSessionId = Yii::$app->getSession()->getId();

        // find all sessions with given sid and destroy them
        $sessionIds = (new Query())
            ->select('id')
            ->from(Yii::$app->getSession()->sessionTable)
            ->where(['keycloak_sid' => $sid])
            ->column();

        // Check if the current session is in the list of sessions to destroy
        $shouldDestroyCurrentSession = in_array($currentSessionId, $sessionIds, true);

        foreach ($sessionIds as $sessionId) {
            if (!Yii::$app->getSession()->destroySession($sessionId)) {
                // RFC: Consider already-logged-out states as successful
                $this->logInfo("Could not destroy session {$sessionId}, possibly already destroyed");
            } else {
                $this->logInfo(['single session id' => $sessionId]);
            }
        }

        // If the current session was destroyed, we need to logout the user and destroy the current session
        if ($shouldDestroyCurrentSession) {
            $this->logInfo("Current session matched keycloak_sid, logging out user");

            // Logout the user
            if (!Yii::$app->getUser()->getIsGuest()) {
                Yii::$app->getUser()->logout(false); // Don't destroy session here, we'll do it manually
            }

            // Destroy the current session
            Yii::$app->getSession()->destroy();
        }

        return '';
    }

    public function actionLogout()
    {
        /** @var UserEvent $event */
        $event = $this->make(UserEvent::class, [Yii::$app->getUser()->getIdentity()]);

        $this->trigger(UserEvent::EVENT_BEFORE_LOGOUT, $event);

        try {
            /** @var Keycloak $client */
            $client = Yii::$app->authClientCollection->getClient($this->keycloakAuthClientId);

            // Check if user is logged in via keycloak by checking the access token type
            if ($client instanceof Keycloak && $client->getAccessToken() instanceof OAuthToken) {
                $logoutUrl = $this->keycloakFrontChannelLogoutUrl($client, $this->skipLogoutConfirmation);
                if (!empty($logoutUrl)) {
                    Yii::$app->response->redirect($logoutUrl)->send();
                    $this->trigger(UserEvent::EVENT_AFTER_LOGOUT, $event);
                    Yii::$app->end();
                } else {
                    $this->logError('Cannot logout user from client');
                }
            }
        } catch (ClientErrorResponseException $exception) {
            // Token is not active anymore. Skipping logout from keycloak as its session should be already expired at this point
            $this->logException($exception);
        } catch (InvalidArgumentException $exception) {
            // Client is not found in collection
            $this->logException($exception);
        }

        if (Yii::$app->getUser()->logout()) {
            $this->trigger(UserEvent::EVENT_AFTER_LOGOUT, $event);
        }

        return $this->goHome();
    }

    /**
     * Logout the user
     *
     * @param Keycloak $client
     * @param bool $skipLogoutConfirmation
     *
     * @return string|null
     */
    protected function keycloakFrontChannelLogoutUrl(Keycloak $client, bool $skipLogoutConfirmation = true): ?string
    {
        $logoutUrl = null;
        // Check if logout confirmation is active or not
        if ($skipLogoutConfirmation) {
            // Check if Keycloak has front channel log out active
            if ($client->getConfigParam('frontchannel_logout_supported', false)) {
                // get the token data
                $accessToken = $client->getAccessToken();
                // check if we have an ID token to trigger the logout with no confirmation
                if ($accessToken?->getParam('id_token')) {
                    $logoutUrl = $client->getConfigParam('end_session_endpoint') . '?id_token_hint=' . $accessToken->getParam('id_token') . '&post_logout_redirect_uri=' . ($this->postLogoutRedirectUrl ?? Url::base(true));
                } else { // If there's no id token, logout the user with the default confirmation
                    $logoutUrl = $client->getConfigParam('end_session_endpoint') . '&post_logout_redirect_uri=' . ($this->postLogoutRedirectUrl ?? Url::base(true));
                }
            }
        } else {
            // If confirmation is enabled and front channel log out is active
            if ($client->getConfigParam('frontchannel_logout_supported', false)) {
                $logoutUrl = $client->getConfigParam('end_session_endpoint') . '&post_logout_redirect_uri=' . ($this->postLogoutRedirectUrl ?? Url::base(true));
            }
        }
        return $logoutUrl;
    }
}
