<?php

namespace dmstr\usuario\keycloak\controllers;

use Da\User\AuthClient\Keycloak;
use Da\User\Contracts\AuthClientInterface;
use Da\User\Event\SocialNetworkAuthEvent;
use Da\User\Event\UserEvent;
use Da\User\Model\SocialNetworkAccount;
use Da\User\Model\User;
use dmstr\usuario\keycloak\traits\AuditLogTrait;
use dmstr\usuario\keycloak\actions\AuthAction;
use Yii;
use yii\authclient\ClientErrorResponseException;
use yii\authclient\OAuthToken;
use yii\base\InvalidArgumentException;
use yii\base\InvalidConfigException;
use yii\db\Query;
use yii\helpers\Url;
use yii\web\ServerErrorHttpException;

class SecurityController extends \Da\User\Controller\SecurityController
{
    use AuditLogTrait;

    /**
     * Base behaviour, unchanged: guest -> authenticate, logged-in -> connect-to-session.
     * Byte-identical to previous releases (backwards compatible default).
     */
    const SOCIAL_LOGIN_MODE_LEGACY = 'legacy';
    /**
     * Option B: connect only if the returned identity provably belongs to the SAME user;
     * otherwise log out the stale session and authenticate as the true identity.
     */
    const SOCIAL_LOGIN_MODE_GUARDED = 'guarded';
    /**
     * Option A: always authenticate via the token identity; never connect-to-session.
     */
    const SOCIAL_LOGIN_MODE_AUTHENTICATE = 'authenticate';

    public string $keycloakAuthClientId = 'keycloak';
    public bool $overrideAuthRedirect = true;
    public bool $skipLogoutConfirmation = true;
    public string $postLogoutRedirectUrl;
    // Default IDP hint for Keycloak
    public string $idp_hint_param = 'kc_idp_hint';

    /**
     * Controls how an OIDC login callback is handled when a local session already exists.
     *
     * DEFAULT = 'legacy' -> identical to previous releases (backwards compatible).
     * Pure SSO/Keycloak deployments (where the auth endpoint IS the primary login) SHOULD set
     * 'guarded' (recommended) or 'authenticate', so a returned identity can never be bound to a
     * foreign, still-open session. See README for the full rationale.
     *
     * @see SOCIAL_LOGIN_MODE_LEGACY
     * @see SOCIAL_LOGIN_MODE_GUARDED
     * @see SOCIAL_LOGIN_MODE_AUTHENTICATE
     */
    public string $socialLoginMode = self::SOCIAL_LOGIN_MODE_LEGACY;

    /**
     * @inheritdoc
     * @throws InvalidConfigException on an unknown $socialLoginMode value.
     */
    public function init()
    {
        parent::init();

        // Reject typos loudly: an unknown mode must NEVER silently fall back to legacy,
        // which would leave a consumer that meant to opt in to hardening still vulnerable.
        $validModes = [
            self::SOCIAL_LOGIN_MODE_LEGACY,
            self::SOCIAL_LOGIN_MODE_GUARDED,
            self::SOCIAL_LOGIN_MODE_AUTHENTICATE,
        ];
        if (!in_array($this->socialLoginMode, $validModes, true)) {
            throw new InvalidConfigException(sprintf(
                'Invalid socialLoginMode "%s". Allowed values: %s.',
                $this->socialLoginMode,
                implode(', ', $validModes)
            ));
        }

        // Nudge SSO deployments still on the (backwards-compatible) legacy default: legacy binds a
        // returned identity to any open session without an identity check. Harmless for classic
        // account-linking, risky for pure SSO logins where this endpoint is the primary login.
        if ($this->socialLoginMode === self::SOCIAL_LOGIN_MODE_LEGACY) {
            try {
                $hasKeycloak = Yii::$app->has('authClientCollection')
                    && Yii::$app->authClientCollection->hasClient($this->keycloakAuthClientId);
            } catch (\Throwable $e) {
                $hasKeycloak = false;
            }
            if ($hasKeycloak) {
                Yii::warning(
                    'socialLoginMode is "legacy" while a Keycloak auth client ("' . $this->keycloakAuthClientId
                    . '") is configured. For SSO deployments set socialLoginMode to "guarded" to prevent'
                    . ' binding a returned identity to a foreign, still-open session.',
                    __METHOD__
                );
            }
        }
    }

    /**
     * @inheritdoc
     */
    public function actions()
    {
        $actions = parent::actions();
        if ($this->overrideAuthRedirect) {
            // In 'authenticate' mode even a logged-in callback resolves via the token identity;
            // 'legacy' and 'guarded' both route through connect() (dispatched in connect()).
            $loggedInCallback = ($this->socialLoginMode === self::SOCIAL_LOGIN_MODE_AUTHENTICATE)
                ? [$this, 'authenticate']
                : [$this, 'connect'];
            // Original redirect view introduces some wierd js magic. We don't want that so we overload it.
            $actions['auth'] = [
                'class' => AuthAction::class,
                'successCallback' => Yii::$app->user->isGuest
                    ? [$this, 'authenticate']
                    : $loggedInCallback,
                'redirectView' => dirname(__DIR__) . '/views/security/redirect.php',
                'idp_hint_param' => $this->idp_hint_param
            ];
        }
        return $actions;
    }

    /**
     * Dispatches the login-callback-with-existing-session case according to $socialLoginMode.
     *
     * legacy       -> parent::connect() (byte-identical to previous releases)
     * guarded      -> connectGuarded()  (bind only if provably the same user)
     * authenticate -> authenticate()    (safety net; the callback wiring already routes here)
     *
     * @inheritdoc
     */
    public function connect(AuthClientInterface $client)
    {
        switch ($this->socialLoginMode) {
            case self::SOCIAL_LOGIN_MODE_GUARDED:
                return $this->connectGuarded($client);
            case self::SOCIAL_LOGIN_MODE_AUTHENTICATE:
                // Safety net in case the callback still routes to connect() while in this mode.
                return $this->authenticate($client);
            case self::SOCIAL_LOGIN_MODE_LEGACY:
                return parent::connect($client);
            default:
                // Unreachable: init() validates $socialLoginMode. Fail loud, never silent-legacy.
                throw new InvalidConfigException('Invalid socialLoginMode "' . $this->socialLoginMode . '".');
        }
    }

    /**
     * Guarded connect: bind the returned identity to the current session ONLY if it provably
     * belongs to the same user (owner resolved by immutable sub, else by verified e-mail).
     * On any mismatch the stale session is logged out and the true identity is authenticated,
     * so a returned identity is never "captured" by a foreign, still-open session.
     *
     * @param AuthClientInterface $client
     * @return bool
     */
    protected function connectGuarded(AuthClientInterface $client)
    {
        // Guests must never reach the connect path; be defensive (mirrors parent::connect()).
        if (Yii::$app->user->isGuest) {
            Yii::$app->session->setFlash('danger', Yii::t('usuario', 'Something went wrong'));
            return false;
        }

        $sub = $client->getUserId();
        $attributes = $client->getUserAttributes();
        // Strict: a missing email_verified claim counts as NOT verified (stricter than the app
        // handlers' `isset && === false`). Documented in the README.
        $emailVerified = $attributes['email_verified'] ?? false;
        $verifiedMail = ($emailVerified === true) ? $client->getEmail() : null;
        $sessionUser = Yii::$app->user->identity;

        // 1) Resolve the true owner of the returned identity (same precedence as authenticate):
        //    a) by immutable sub, else b) by verified e-mail.
        $account = SocialNetworkAccount::find()
            ->where(['provider' => $client->getId(), 'client_id' => $sub])
            ->one();
        $owner = $account?->user;
        // Guard against empty e-mail: ['email' => null] would match rows with email IS NULL.
        if ($owner === null && !empty($verifiedMail)) {
            $owner = User::findOne(['email' => $verifiedMail]);
        }

        // 2a) Provably the same person -> legitimate connect (a new sub for the current user).
        if ($owner !== null && (int)$owner->id === (int)$sessionUser->id) {
            if ($account === null) {
                // Brand-new sub for this user: create with email/username populated (unlike the
                // base connect path, so no new NULL rows are produced).
                $account = $this->make(SocialNetworkAccount::class, [], [
                    'provider' => $client->getId(),
                    'client_id' => $sub,
                    'data' => json_encode($attributes),
                    'user_id' => $sessionUser->id,
                    'username' => $client->getUserName(),
                    'email' => $verifiedMail,
                ]);
            } else {
                // Orphan row (user_id NULL) -> UPDATE the existing row, never insert
                // (would violate UNIQUE(provider, client_id)). Backfill empty columns.
                $account->user_id = $sessionUser->id;
                $account->username = $account->username ?: $client->getUserName();
                $account->email = $account->email ?: $verifiedMail;
            }

            /** @var SocialNetworkAuthEvent $event */
            $event = $this->make(SocialNetworkAuthEvent::class, [$account, $client]);
            $this->trigger(SocialNetworkAuthEvent::EVENT_BEFORE_CONNECT, $event);

            $account->save(false);

            Yii::$app->session->setFlash('success', Yii::t('usuario', 'Your account has been connected'));
            $this->trigger(SocialNetworkAuthEvent::EVENT_AFTER_CONNECT, $event);

            return true;
        }

        // 2b) Different/unknown identity -> the stale session must not "capture" it.
        $this->logInfo([
            'message' => 'social-login identity mismatch: logging out stale session, re-authenticating as token identity',
            'session_user_id' => $sessionUser->id ?? null,
            'sub' => $sub,
            'email' => $verifiedMail,
        ]);

        // Preserve the in-memory Keycloak token: logout() destroys the session state that holds
        // it, so a per-request token-revalidation handler would otherwise hit a null token
        // (uncaught PHP Error -> 500 for the correctly logged-in user on the next request).
        $token = $client->getAccessToken();

        Yii::$app->user->logout();

        // Resolve/create the true identity (triggers BEFORE_AUTHENTICATE incl. email_verified check).
        $result = $this->authenticate($client);

        // Re-persist the token into the freshly created session.
        if ($token !== null) {
            $client->setAccessToken($token);
        }

        return $result;
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

                // refresh access token before login to ensure it is not expired
                // this will throw an ClientErrorResponseException
                $client->refreshAccessToken($client->getAccessToken());

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
