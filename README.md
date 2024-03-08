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
KEYCLOAK_CLIENT_ID=your-client
KEYCLOAK_CLIENT_SECRET=your-secret
KEYCLOAK_ISSUER_URL=http://keycloak-local:8080/realms/your-realm
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
use yii\web\ForbiddenHttpException;

return [
    'modules' => [
        'user' => [
            'controllerMap' => [
                'security' => [
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
class User extends \dmstr\web\User
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
use yii\authclient\ClientErrorResponseException;
use yii\base\Event;
use yii\base\InvalidParamException;
use yii\web\Application;

// Save the auth client info to differentiate afterward from which auth client the user was authenticated
Event::on(SecurityController::class, SocialNetworkAuthEvent::EVENT_AFTER_AUTHENTICATE, function (SocialNetworkAuthEvent $event) {
    Yii::$app->getUser()->setAuthSource($event->getClient()->getId());
});

return [
    'on ' . Application::EVENT_BEFORE_REQUEST => function () {
        $user = Yii::$app->getUser();
        $keycloakClientId = 'keycloak';
        if ($user && !$user->getIsGuest() && Yii::$app->getUser()->getAuthSource() === $keycloakClientId) {
            try {
                /** @var Keycloak $keycloak */
                $keycloak = Yii::$app->authClientCollection->getClient($keycloakClientId);
                // WARNING: Yii2 auth client package uses deprecated exception
            } catch (InvalidParamException $exception) {
                Yii::error($exception->getMessage());
            }
            // Check if the token is expired. If so, the getAccessToken throws an error
            // INFO: This also triggers a request to keycloak for every request the app makes!
            try {
                $keycloak->getAccessToken();
            } catch (ClientErrorResponseException $exception) {
                Yii::info($exception->getMessage());
                // If token is expired log out the user
                $user->logout();
            }
        }
    },
    'components' => [
        'user' => [
            'class' => User::class 
        ]
    ]
];
```

**Change the login url so the site redirect you directly to the keycloak login page**

```php
return [
    'components' => [
        'user' => [
            'loginUrl' => ['/user/security/auth', 'authclient' => 'keycloak']
        ]
    ]
];
```

## TokenRoleRule

This rule allows you to assign roles to users based on the roles they have in keycloak. This is useful if you want to
use keycloak as a single source of truth for your user roles. Note that the role names in keycloak must match the role
and should be assiged to any logged in user.
