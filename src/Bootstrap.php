<?php

namespace dmstr\usuario\keycloak;

use bizley\jwt\Jwt;
use Da\User\Controller\SecurityController;
use Da\User\Event\SocialNetworkAuthEvent;
use dmstr\tokenManager\components\TokenManager;
use dmstr\usuario\keycloak\clients\Keycloak;
use Lcobucci\JWT\Token;
use Lcobucci\JWT\UnencryptedToken;
use yii\authclient\OAuthToken;
use yii\base\BootstrapInterface;
use yii\base\Event;
use yii\helpers\VarDumper;
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
                    // save parsed token via token manager
                    $tokenManager->setToken($parsedToken);
                    return; // get out of here
                }

            }
            Yii::$app->getUser()->logout();
            throw new BadRequestHttpException(\Yii::t('usuario.keycloak','Invalid token'));
        });
    }
}
