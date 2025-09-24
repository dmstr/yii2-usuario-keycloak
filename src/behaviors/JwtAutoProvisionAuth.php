<?php

namespace dmstr\usuario\keycloak\behaviors;

use bizley\jwt\JwtTools;
use Da\User\Event\UserEvent;
use Da\User\Model\SocialNetworkAccount;
use Da\User\Model\User;
use Da\User\Traits\ContainerAwareTrait;
use Exception;
use Yii;
use yii\authclient\ClientInterface;
use yii\authclient\Collection;
use yii\base\InvalidArgumentException;
use yii\base\InvalidConfigException;
use yii\db\Exception as DbException;
use yii\di\Instance;
use yii\filters\auth\HttpBearerAuth;
use yii\helpers\Json;
use yii\web\BadRequestHttpException;
use yii\web\IdentityInterface;
use yii\web\UnauthorizedHttpException;
use yii\web\UnprocessableEntityHttpException;
use yii\web\User as UserComponent;

class JwtAutoProvisionAuth extends HttpBearerAuth
{
    use ContainerAwareTrait;

    /**
     * component id of the jwt component
     */
    public JwtTools|string $jwt = 'jwt';

    /**
     * ID of the auth client
    */
    public string $authClientId = 'keycloak';

    /**
     * component id of the auth client collection component
     */
    public string|Collection $authClientCollection = 'authClientCollection';

    private ClientInterface $_authClient;

    /**
     * enable or disable debug logging messages
     */
    public bool $debug = false;

    /**
     * @var null|callable
     */
    public $afterUserValidated;

    /**
     * @throws \yii\base\InvalidConfigException If configuration is not correct
     */
    public function init()
    {
        parent::init();

        $this->authClientCollection = Instance::ensure($this->authClientCollection, Collection::class);

        try {
            $this->_authClient = $this->authClientCollection->getClient($this->authClientId);
        } catch (InvalidArgumentException) {
            throw new InvalidConfigException('authClientId does not exist');
        }

        if (is_string($this->jwt)) {
            $this->jwt = Instance::ensure($this->jwt, JwtTools::class);
        }

        if (!$this->jwt instanceof JwtTools) {
            throw new InvalidConfigException('jwt must be instance of ' . JwtTools::class);
        }
    }

    /**
     * @throws \yii\web\BadRequestHttpException
     * @throws \yii\web\UnauthorizedHttpException
     * @throws \yii\web\UnprocessableEntityHttpException
     * @return \yii\web\IdentityInterface|null
     */
    public function authenticate($user, $request, $response)
    {
        $authHeader = $request->getHeaders()->get($this->header);

        // Header is not set
        if ($authHeader === null) {
            throw new BadRequestHttpException(Yii::t('usuario-keycloak', '{header} header is not set', [
                'header' => $this->header
            ]));
        }

        // Header value does not match bearer pattern
        if (preg_match((string)$this->pattern, $authHeader, $matches) === false) {
            throw new BadRequestHttpException(Yii::t('usuario-keycloak', 'Token is not set'));
        }

        // JWT in string form
        $authHeaderValue = $matches[1] ?? null;

        $this->logDebug($authHeaderValue ?: 'Header value is empty');

        if (!is_string($authHeaderValue)) {
            throw new BadRequestHttpException(Yii::t('usuario-keycloak', 'Token is invalid'));
        }

        // Check if the token is valid
        try {
            Yii::$app->jwt->assert($authHeaderValue);
        } catch (Exception $exception) {
            $this->logException($exception);
            throw new UnauthorizedHttpException(Yii::t('usuario-keycloak', 'Token constraint failed'));
        }

        /** @var User $identity */
        $identity = $this->findOrCreateUser($user, $authHeaderValue);

        if ($identity instanceof IdentityInterface) {
            $this->logInfo('Logging in new user #' . $identity->getId());
            if (is_callable($this->afterUserValidated)) {
                if (!call_user_func($this->afterUserValidated, $identity, $identity->getSocialNetworkAccounts()[$this->authClientId] ?? null, $authHeaderValue)) {
                    $this->logInfo('AfterUserValidated failed');
                    return null;
                }
            }
        }
        return $identity;
    }

    public function findOrCreateUser(UserComponent $user, string $authHeaderValue): ?IdentityInterface
    {
        $existingIdentity = $user->loginByAccessToken($authHeaderValue, get_class($this));

        // Does the identity exist? Good.
        if ($existingIdentity instanceof IdentityInterface) {
            return $existingIdentity;
        }

        $newIdentity = $this->createOrConnectUserFromToken($authHeaderValue);

        // There was an error creating a new user?
        if ($newIdentity === null) {
            throw new UnprocessableEntityHttpException(Yii::t('usuario-keycloak', 'Unable to process the request'));
        }

        // try again with newly created user
        return $user->loginByAccessToken($authHeaderValue, get_class($this));
    }

    protected function getAuthClient(): ClientInterface
    {
        return $this->_authClient;
    }

    protected function logException(Exception $exception): void
    {
        if (Yii::$app->hasModule('audit')) {
            Yii::$app->getModule('audit')->exception($exception);
        } else {
            Yii::error($exception->getMessage());
        }
    }

    protected function logInfo(mixed $data): void
    {
        if (Yii::$app->hasModule('audit')) {
            Yii::$app->getModule('audit')->data('info', $data);
        } else {
            Yii::info($data);
        }
    }

    protected function logError(string $message): void
    {
        if (Yii::$app->hasModule('audit')) {
            Yii::$app->getModule('audit')->errorMessage($message);
        } else {
            Yii::error($message);
        }
    }

    protected function logDebug(string $message): void
    {
        if ($this->debug) {
            if (Yii::$app->hasModule('audit')) {
                Yii::$app->getModule('audit')->data('debug', $message);
            } else {
                Yii::debug($message);
            }
        }
    }

    protected function createOrConnectUserFromToken(string $jwt): IdentityInterface|null
    {
        // token should be valid at this point so there should be no error here except if the token expired in the last few milliseconds
        $token = $this->jwt->getParser()->parse($jwt);

        $claims = $token->claims();

        $email = $claims->get('email');

        // Check if a user with email form claim exists so we can connect it
        $user = $this->make(User::class)::findOne(['email' => $email]);

        $transaction = $this->make(User::class)::getDb()->beginTransaction();

        if ($user === null) {
            // create user
            $this->logInfo('Creating new user based of given jwt');
            /** @var User $user */
            $user = $this->make(User::class, [], [
                'scenario' => 'connect',
                'username' => $claims->get('preferred_username', $claims->get('sub')),
                'email' => $email, // Must be present in the token
                'password_hash' => 'x', // field is required.
                'confirmed_at' => time()
            ]);

            /** @var UserEvent $event */
            $event = $this->make(UserEvent::class, [$user]);

            $user->trigger(UserEvent::EVENT_BEFORE_REGISTER, $event);
            if (!$user->save()) {
                $transaction->rollBack();
                $this->logError('Error creating user');
                $this->logInfo($user->getErrors());
                return null;
            }
            $isNewUser = true;
            $this->logInfo('User created');
        } else {
            $isNewUser = false;
            $this->logInfo('User does already exist');
        }

        $this->logInfo('Going to connect social network account');

        // create and attach social account
        /** @var SocialNetworkAccount $socialNetworkAccount */
        $socialNetworkAccount = $this->make(SocialNetworkAccount::class, [], [
            'provider' => $this->getAuthClient()->getId(),
            'client_id' => $claims->get('sub'),
            'data' => Json::encode($claims->all()),
            'user_id' => $user->id,
            'username' => $user->username,
            'email' => $user->email
        ]);

        // No events for social network account here because in the original connect service the event is triggered on the controller and not on the model

        // we need to wrap this in a try-catch block as there are no rules in this model...
        try {
            if (!$socialNetworkAccount->save()) {
                $transaction->rollBack();
                $this->logError('Error connect social network account');
                $this->logInfo($socialNetworkAccount->getErrors());
                return null;
            }
        } catch (DbException $exception) {
            $this->logError('Error creating social network account');
            $this->logException($exception);
            return null;
        }

        $this->logInfo('Connected social network account to user');

        try {
            $transaction->commit();
            // trigger this but only transaction is successful and is new user
            if ($isNewUser) {
                /** @var UserEvent $event */
                $event = $this->make(UserEvent::class, [$user]);
                $user->trigger(UserEvent::EVENT_AFTER_REGISTER, $event);
            }


            return $user;
        } catch (DbException $exception) {
            $this->logException($exception);
        }
        return null;
    }
}
