<?php

namespace dmstr\usuario\keycloak\controllers;

use Da\User\AuthClient\Keycloak;
use Da\User\Event\UserEvent;
use Yii;
use yii\authclient\ClientErrorResponseException;
use yii\authclient\OAuthToken;
use yii\helpers\Url;

class SecurityController extends \Da\User\Controller\SecurityController
{
    public string $keycloakAuthClientId = 'keycloak';
    public bool $overrideAuthRedirect = true;
    public bool $skipLogoutConfirmation = true;

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

    public function actionLogout()
    {
        /** @var UserEvent $event */
        $event = $this->make(UserEvent::class, [Yii::$app->getUser()->getIdentity()]);

        $this->trigger(UserEvent::EVENT_BEFORE_LOGOUT, $event);

        /** @var Keycloak $client */
        $client = Yii::$app->authClientCollection->getClient($this->keycloakAuthClientId);

        try {
            // Check if user is logged in via keycloak by checking the access token type
            if ($client instanceof Keycloak && $client->getAccessToken() instanceof OAuthToken) {
                $logoutUrl = self::keycloakFrontChannelLogoutUrl($client, $this->skipLogoutConfirmation);
                if (!empty($logoutUrl) && Yii::$app->getUser()->logout()) {
                    Yii::$app->response->redirect($logoutUrl)->send();
                    $this->trigger(UserEvent::EVENT_AFTER_LOGOUT, $event);
                    Yii::$app->end();
                } else {
                    Yii::warning('Cannot logout user from client');
                }
            }
        } catch (ClientErrorResponseException $exception) {
            // Token is not active anymore. Skipping logout from keycloak as its session should be already expired at this point
            Yii::warning($exception->getMessage());
        }

        if (Yii::$app->getUser()->logout()) {
            $this->trigger(UserEvent::EVENT_AFTER_LOGOUT, $event);
        }

        return $this->goHome();
    }

    /**
     * Logout the user
     * @param Keycloak $client
     * @param bool $skipLogoutConfirmation
     * @return string|null
     */
    protected static function keycloakFrontChannelLogoutUrl(Keycloak $client, bool $skipLogoutConfirmation = true): ?string
    {
        $logoutUrl = null;
        // Check if logout confirmation is active or not
        if($skipLogoutConfirmation) {
            // Check if Keycloak has front channel log out active
            if ($client->getConfigParam('frontchannel_logout_supported', false)) {
                // get the token data
                $accessToken = $client->getAccessToken();
                // check if we have an ID token to trigger the logout with no confirmation
                if($accessToken?->getParam('id_token')) {
                    $logoutUrl = $client->getConfigParam('end_session_endpoint') . '?id_token_hint=' . $accessToken->getParam('id_token') . '&post_logout_redirect_uri=' . Url::base(true);
                }
                // If there's no id token, logout the user with the default confirmation
                else {
                    $logoutUrl = $client->getConfigParam('end_session_endpoint');
                }
            }
        } else {
            // If confirmation is enabled and front channel log out is active
            if ($client->getConfigParam('frontchannel_logout_supported', false)) {
                $logoutUrl = $client->getConfigParam('end_session_endpoint');
            }
        }
        return $logoutUrl;
    }
}
