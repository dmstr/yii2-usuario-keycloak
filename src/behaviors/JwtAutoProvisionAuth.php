<?php

namespace dmstr\usuario\keycloak\behaviors;

use bizley\jwt\JwtTools;
use Da\User\Event\UserEvent;
use Da\User\Model\SocialNetworkAccount;
use Da\User\Model\User;
use Da\User\Traits\ContainerAwareTrait;
use dmstr\usuario\keycloak\traits\AuditLogTrait;
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
use yii\web\ConflictHttpException;
use yii\web\IdentityInterface;
use yii\web\UnauthorizedHttpException;
use yii\web\UnprocessableEntityHttpException;
use yii\web\User as UserComponent;

class JwtAutoProvisionAuth extends HttpBearerAuth
{
    use ContainerAwareTrait;
    use AuditLogTrait;

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
            $this->logInfo('Logging in user #' . $identity->getId());
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

    protected function createOrConnectUserFromToken(string $jwt): IdentityInterface|null
    {
        // token should be valid at this point so there should be no error here except if the token expired in the last few milliseconds
        $token = $this->jwt->getParser()->parse($jwt);

        $claims = $token->claims();

        $email = $claims->get('email');
        $sub = $claims->get('sub');
        $provider = $this->getAuthClient()->getId();

        // Resolve the social account by its natural key (provider, client_id) WITHOUT user_id and
        // BEFORE creating any user. This closes two failure modes when the sub is already linked:
        //  - silently authenticating the (possibly wrong) linked user, and
        //  - spawning a side-effect user whose account insert then fails on UNIQUE(provider, client_id).
        /** @var SocialNetworkAccount|null $socialNetworkAccount */
        $socialNetworkAccount = SocialNetworkAccount::findOne([
            'provider' => $provider,
            'client_id' => $sub,
        ]);

        // Check if a user with email form claim exists so we can connect it
        $user = $this->make(User::class)::findOne(['email' => $email]);

        // A sub already linked to a DIFFERENT user than the token's e-mail resolves to is a
        // mislink (recidivism signal). Refuse loudly instead of authenticating the wrong user;
        // no user is created because we bail out before the transaction begins.
        if ($socialNetworkAccount !== null
            && $socialNetworkAccount->user_id !== null
            && $user !== null
            && (int)$socialNetworkAccount->user_id !== (int)$user->id) {
            $this->logError(sprintf(
                'JWT auto-provision refused: sub "%s" is linked to user #%s, but email "%s" resolves to user #%s',
                (string)$sub,
                $socialNetworkAccount->user_id,
                (string)$email,
                $user->id
            ));
            throw new ConflictHttpException(Yii::t('usuario-keycloak', 'This social account is linked to a different user.'));
        }

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

        // create and attach social account (natural-key lookup already performed above)
        if ($socialNetworkAccount === null) {
            $this->logInfo('Social network Account not found, creating new one.');
            $socialNetworkAccount = $this->make(SocialNetworkAccount::class, [], [
                'provider' => $provider,
                'client_id' => $sub,
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
                $this->logInfo('Social Network Account created');
            } catch (DbException $exception) {
                $transaction->rollBack();
                $this->logError('Error creating social network account');
                $this->logException($exception);
                return null;
            }
            $this->logInfo('Connected social network account to user');
        } else {
            $this->logInfo('Social Network Account already exists, skipping creation.');
        }

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
