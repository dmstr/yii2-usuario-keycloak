<?php

namespace dmstr\usuario\keycloak;

use bizley\jwt\Jwt;
use Da\User\Controller\RegistrationController;
use Da\User\Controller\SecurityController;
use Da\User\Event\SocialNetworkAuthEvent;
use Da\User\Event\SocialNetworkConnectEvent;
use dmstr\tokenManager\components\TokenManager;
use dmstr\tokenManager\event\TokenManagerEvent;
use dmstr\usuario\keycloak\clients\Keycloak;
use yii\authclient\OAuthToken;
use yii\base\BootstrapInterface;
use yii\base\Event;
use yii\web\BadRequestHttpException;
use Yii;

/**
 * --- PROPERTIES ---
 *
 * @author Elias Luhr
 */
class Bootstrap implements BootstrapInterface
{
    public string $clientName;
    public string $clientTitle;
    public string $clientAuthUrl;
    public string $clientTokenUrl;
    public string $clientIssuerUrl;
    public string $clientClientId;
    public string $clientClientSecret;

    /**
     * array of src -> dst attribute names that should be mapped from token (src)
     * to dst key in clients\Keycloak::initUserAttributes
     *
     * @var array
     */
    public array $clientTokenAttributeMap = [];
    public string $jwtComponentId = 'jwt';
    public string $tokenManagerComponentId = 'tokenManager';

    public function __construct()
    {
        $this->clientName = getenv('KEYCLOAK_CLIENT_ID');
        $this->clientTitle = getenv('KEYCLOAK_CLIENT_TITLE');
    }

    /**
     * @param \yii\base\Application $app
     * @return void
     */
    public function bootstrap($app)
    {
        // Configure keycloak client
        $clients = $app->authClientCollection->getClients();
        $clients[$this->clientName] = [
            'class' => Keycloak::class,
            'authUrl' => $this->clientAuthUrl,
            'issuerUrl' => $this->clientIssuerUrl,
            'tokenUrl' => $this->clientTokenUrl,
            'clientId' => $this->clientClientId,
            'clientSecret' => $this->clientClientSecret,
            'name' => $this->clientName,
            'title' => $this->clientTitle,
            'clientTokenAttributeMap' => $this->clientTokenAttributeMap
        ];
        $app->authClientCollection->setClients($clients);

        // Persist social network account because it is not persisted by default
        Event::on(SecurityController::class, SocialNetworkAuthEvent::EVENT_BEFORE_AUTHENTICATE, function (SocialNetworkAuthEvent $event) {
            if ($event->getClient()->getName() === $this->clientName) {
                $event->account->save(false);
            }
        });

        // Disable mailer transport for social network connect to prevent sending welcome email
        $oldUseFileTransport = Yii::$app->getMailer()->useFileTransport;
        // https://github.com/2amigos/yii2-usuario/issues/401#issuecomment-776502277
        Event::on(RegistrationController::class, SocialNetworkConnectEvent::EVENT_BEFORE_CONNECT, function (SocialNetworkConnectEvent $event) {
            Yii::$app->getMailer()->useFileTransport = true;
        });

        // Use old value after connect
        Event::on(RegistrationController::class, SocialNetworkConnectEvent::EVENT_AFTER_CONNECT, function (SocialNetworkConnectEvent $event) use ($oldUseFileTransport) {
            Yii::$app->getMailer()->useFileTransport = $oldUseFileTransport;
        });

        // Create/update attached account
        Event::on(SecurityController::class, SocialNetworkAuthEvent::EVENT_BEFORE_AUTHENTICATE, function (SocialNetworkAuthEvent $event) {
            if ($event->getClient()->getName() === $this->clientName) {
                $event->account->save(false);
            }
        });

        // Retrieve and process and save token
        Event::on(SecurityController::class, SocialNetworkAuthEvent::EVENT_AFTER_AUTHENTICATE, function (SocialNetworkAuthEvent $event) {
            $oauthAccessToken = $event->getClient()->getAccessToken();
            // check ig access token is in expected format
            if ($oauthAccessToken instanceof OAuthToken) {
                // get token as string
                $token = $oauthAccessToken->getToken();
                /** @var Jwt $jwtComponent */
                $jwtComponent = Yii::$app->get($this->jwtComponentId);
                // parse string representation of the token to a token object
                $parsedToken = $jwtComponent->getParser()->parse($token);
                // validate the token
                if ($jwtComponent->validate($parsedToken)) {
                    /** @var TokenManager $tokenManager */
                    $tokenManager = Yii::$app->get($this->tokenManagerComponentId);
                    // Create token event
                    $tokenEvent = Yii::createObject(TokenManagerEvent::class, [$parsedToken]);
                    // Fire before token set event
                    $tokenManager->trigger(TokenManagerEvent::EVENT_BEFORE_SET_TOKEN, $tokenEvent);
                    // save parsed token via token manager
                    $tokenManager->setToken($parsedToken);
                    // Fire after token set event
                    $tokenManager->trigger(TokenManagerEvent::EVENT_AFTER_SET_TOKEN, $tokenEvent);
                    return; // get out of here
                }

            }
            Yii::$app->getUser()->logout();
            throw new BadRequestHttpException(\Yii::t('usuario.keycloak', 'Invalid token'));
        });
    }
}
