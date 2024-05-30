# Yii2 usuario keycloak client

## Installation

Install the package via composer

```bash
composer require dmstr/yii2-usuario-keycloak
```

For the installation of usuario see [usuario docs](https://yii2-usuario.readthedocs.io/en/latest/)

## Setup

To run a keycloak using Docker (compose) please see [docker-compose.keycloak.yml](docker/docker-compose.keycloak.yml) in
the docker folder

For local development you should add keycloak-local to your /etc/hosts like this:
127.0.0.1 keycloak-local

You may need to replace 127.0.0.1 with your docker ip

## Configuration

**This part of config is mandatory. With this we add keycloak as a "social network"**

```dotenv
KEYCLOAK_CLIENT_NAME=Keycloak
KEYCLOAK_CLIENT_ID=app
# See credentials tab in example realms app client
KEYCLOAK_CLIENT_SECRET=
KEYCLOAK_ISSUER_URL=http://keycloak-local:8080/realms/example
```

```php
use yii\authclient\Collection;
use Da\User\AuthClient\Keycloak;

return [
    'components' => [
        'authClientCollection' => [
            'class' => Collection::class,
            'clients' => [
                'keycloak' => [
                    'class' => Keycloak::class,
                    'title' => getenv('KEYCLOAK_CLIENT_NAME'),
                    'clientId' => getenv('KEYCLOAK_CLIENT_ID'),
                    'clientSecret' => getenv('KEYCLOAK_CLIENT_SECRET'),
                    'issuerUrl' => getenv('KEYCLOAK_ISSUER_URL')
                ]
            ]
        ],
        'user' => [
            // So that the session do not get mixed up
            'enableAutoLogin' => false
        ]
    ]
]
```

**Enable front channel logout from keycloak when user logs out in app**

```php
use dmstr\usuario\keycloak\controllers\SecurityController;

return [
    'modules' => [
        'user' => [
            'controllerMap' => [
                'security' => [
                    'class' => SecurityController::class
                ]
            ]
        ]
    ] 
]
```

**Only allow login to users with verified emails**

```php
use Da\User\Event\SocialNetworkAuthEvent;
use dmstr\usuario\keycloak\controllers\SecurityController;
use yii\web\ForbiddenHttpException;


return [
    'modules' => [
        'user' => [
            'controllerMap' => [
                'security' => [
                    'class' => SecurityController::class,
                    'on ' . SocialNetworkAuthEvent::EVENT_BEFORE_AUTHENTICATE => function (SocialNetworkAuthEvent $event) {
                        if (isset($event->getClient()->getUserAttributes()['email_verified']) && $event->getClient()->getUserAttributes()['email_verified'] === false) {
                            throw new ForbiddenHttpException(Yii::t('usuario-keycloak', 'Account is not verified. Please confirm your registration email.'));
                        }
                    }
                ]
            ]
        ]
    ]   
]
```

**Disabled the sending of a welcome message when a user is from keycloak**

```php
return [
    'modules' => [
        'user' => [
            'sendWelcomeMailAfterSocialNetworkRegistration' => false
        ]
    ] 
]
```

**If you do not want to allow identity switching. This is recommended because potential RBAC Roles with the
TokenRoleRule may not work correctly**

```php
return [
    'modules' => [
        'user' => [
            'enableSwitchIdentities' => false
        ]
    ] 
]
```

**Logout the user if the keycloak token is expired**

This only works in a web application so add your config accordingl and needs some slight modifications to your user
component. You can copy and use this example or extend your existing user compoent.

```php
<?php

namespace app\components;

use Yii;
use yii\base\InvalidConfigException;

/**
 * @property-read string|null $authSource
 */
class User extends yii\web\User
{
    protected const AUTH_SOURCE_CLIENT_ID_SESSION_KEY = 'authSourceClientId';

    /**
     * @throws InvalidConfigException
     */
    public function setAuthSource(string $clientId): void
    {
        Yii::$app->getSession()->set(self::AUTH_SOURCE_CLIENT_ID_SESSION_KEY, $clientId);
    }

    /**
     * Returns the name of the auth client with which the user has authenticated himself.
     *
     * - null means not authenticated.
     * - 'app' means, not authenticated via an auth client
     *
     * @return string|null
     */
    public function getAuthSource(): ?string
    {
        if ($this->getIsGuest()) {
            return null;
        }

        return Yii::$app->getSession()->get(self::AUTH_SOURCE_CLIENT_ID_SESSION_KEY, 'app');
    }
}
?>
```

```php
use app\components\User;
use Da\User\AuthClient\Keycloak;
use Da\User\Event\SocialNetworkAuthEvent;
use dmstr\usuario\keycloak\controllers\SecurityController;
use yii\base\Exception;
use yii\base\InvalidArgumentException;
use yii\web\Application;

return [
        'on ' . Application::EVENT_BEFORE_REQUEST => function () {
        $user = Yii::$app->getUser();
        $keycloakClientId = 'keycloak';
        if ($user && !$user->getIsGuest() && Yii::$app->getUser()->getAuthSource() === $keycloakClientId) {
            try {
                $jwt = Yii::$app->jwt;
                /** @var Keycloak $keycloak */
                $keycloak = Yii::$app->authClientCollection->getClient($keycloakClientId);
                // Check if token is valid
                if (!$jwt->validate($keycloak->getAccessToken()->getToken())) {
                    // If token is invalid log out the user
                    throw new Exception('Access token invalid.');
                }
            } catch (Exception $exception) {
                Yii::error($exception->getMessage());
                // Logout user if token cannot be revalidated or is revoked
                $user->logout();
            }
        }
    },
    'components' => [
        'user' => [
            'class' => User::class 
        ]
    ],
    'modules' => [
        'user' => [
            'controllerMap' => [
                'security' => [
                    'class' => SecurityController::class,
                    'on ' . SocialNetworkAuthEvent::EVENT_AFTER_AUTHENTICATE => function (SocialNetworkAuthEvent $event) {
                        // Save the auth client info to differentiate afterward from which auth client the user was authenticated
                        Yii::$app->getUser()->setAuthSource($event->getClient()->getId());
                    }
                ]
            ]
        ]
    ] 
];
```

**Change the login url so the site redirect you directly to the keycloak login page**

```php
return [
    'components' => [
        'user' => [
            'loginUrl' => '/user/security/auth?authclient=keycloak'
        ]
    ]
];
```

**User identity to use in rest calls**

We suggest to use the `JwtHttpBearerAuth` from [bizley/yii2jwt](https://github.com/bizley/yii2-jwt) for this. You can
use the following example to implement it in your user

```php
<?php

namespace app\models;

use bizley\jwt\JwtHttpBearerAuth;
use Da\User\Model\SocialNetworkAccount;
use Lcobucci\JWT\Token\Plain;
use yii\base\NotSupportedException;
use Yii;

class User extends \Da\User\Model\User {

    /**
     * @inheritdoc  
     */
    public static function findIdentityByAccessToken($token, $type = null)
    {
        if ($type === JwtHttpBearerAuth::class) {
            /** @var Plain $jwtToken */
            $jwtToken = Yii::$app->jwt->getParser()->parse((string)$token);
                
            $claims = $jwtToken->claims();
            $userClientId = $claims->get('sub');

            /** @var SocialNetworkAccount|null $socialAccount */
            $socialAccount = SocialNetworkAccount::find()->andWhere([
                'provider' => 'keycloak',
                'client_id' => $userClientId
            ])->one();

            if ($socialAccount) {
                return static::find()
                    ->whereId($socialAccount->user_id)
                    ->andWhere(['blocked_at' => null])
                    ->andWhere(['NOT', ['confirmed_at' => null]])
                    ->andWhere(['gdpr_deleted' => 0])
                    ->one();
            }
            
            return null;
        }
        throw new NotSupportedException("Type '$type' is not implemented.");
    }
}
```

Using the identity class

```php
use app\models\User as UserModel;

return [
    'components' => [
        'user' => [
            'identityClass' => UserModel::class
        ]
    ]
]
```

Generate the keys for the jwt

```bash
ssh-keygen -t rsa -b 4096 -m PEM -f jwtRS256.key
# Don't add passphrase
openssl rsa -in jwtRS256.key -pubout -outform PEM -out jwtRS256.key.pub
```

```dotenv
KEYCLOAK_PRIVATE_KEY_FILE=file:///path/to/jwtRS256.key
KEYCLOAK_PUBLIC_KEY_FILE=file:///path/to/jwtRS256.key.pub
```

```php
use bizley\jwt\Jwt;
use Lcobucci\JWT\Validation\Constraint\IssuedBy;
use Lcobucci\JWT\Validation\Constraint\SignedWith;
use Lcobucci\JWT\Validation\Constraint\LooseValidAt;
use Lcobucci\Clock\SystemClock;

return [
    'components' => [
        'jwt' => [
            'class' => Jwt::class,
            'signer' => Jwt::RS256,
            'signingKey' => [
                'key' => getenv('KEYCLOAK_PRIVATE_KEY_FILE'),
                'method' => Jwt::METHOD_FILE,
            ],
            'verifyingKey' => [
                'key' => getenv('KEYCLOAK_PUBLIC_KEY_FILE'),
                'method' => Jwt::METHOD_FILE,
            ],
            'validationConstraints' => function (Jwt $jwt) {
                $config = $jwt->getConfiguration();
                return [
                    new SignedWith($config->signer(), $config->verificationKey()),
                    new IssuedBy(getenv('KEYCLOAK_ISSUER_URL')),
                    new LooseValidAt(SystemClock::fromUTC()),
                ];
            }
        ]
    ]
];
```

if you only want to use validation and parsing you can configure the jwt component like this.

```php
use bizley\jwt\JwtTools;
use Lcobucci\JWT\Validation\Constraint\IssuedBy;
use Lcobucci\JWT\Validation\Constraint\SignedWith;
use Lcobucci\JWT\Validation\Constraint\LooseValidAt;
use Lcobucci\Clock\SystemClock;

return [
    'components' => [
        'jwt' => [
            'class' => JwtTools::class,
            'validationConstraints' => function (JwtTools $jwt) {
                return [
                    new SignedWith($jwt->buildSigner(Jwt::RS256), InMemory::plainText(getenv('KEYCLOAK_PUBLIC_KEY_FILE'))),
                    new IssuedBy(getenv('KEYCLOAK_ISSUER_URL')),
                    new LooseValidAt(SystemClock::fromUTC()),
                ];
            }
        ]
    ]
];
```
In combination with a Keycloak, the value `KEYCLOAK_PUBLIC_KEY_FILE` should be that from the Keycloak Public Key

When using the `JwtHttpBearerAuth` ensure that cors is before the `authenticator` in the `behaviors` of your controller
or module and all access controll stuff is after.

**Auto submit social account registration confirm form**

```php
use Da\User\Controller\RegistrationController;
use ActionEvent;

return [
    'modules' => [
        'user' => [
            'controllerMap' => [
                'registration' => [
                    'class' => RegistrationController::class,
                    'on ' . RegistrationController::EVENT_BEFORE_ACTION => function (ActionEvent $event) {
                        if ($event->action->id === 'connect') {
                            // You may need to change the form id but this is the default
                            $event->action->controller->view->registerJs('if ($(".has-error").length === 0){$("form#User").submit()};');
                        }
                    }
                ]
            ]
        ]
    ] 
]
```
```php

```
## TokenRoleRule

This rule allows you to assign roles to users based on the roles they have in keycloak. This is useful if you want to
use keycloak as a single source of truth for your user roles. Note that the role names in keycloak must match the role
and should be assiged to any logged in user.
