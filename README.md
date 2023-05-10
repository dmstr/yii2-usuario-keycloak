# Yii2 usuario keycloak client

### Installation and Setup

For the installation and setup see [usuario docs](https://yii2-usuario.readthedocs.io/en/latest/)

Install the package via composer
```bash
composer require dmstr/yii2-usuario-keycloak
```

Update your yii2 app config
```php
use bizley\jwt\Jwt;
use dmstr\tokenManager\components\TokenManager;
use dmstr\usuario\keycloak\Bootstrap;
use Lcobucci\Clock\SystemClock;
use Lcobucci\JWT\Validation\Constraint\IssuedBy;
use Lcobucci\JWT\Validation\Constraint\LooseValidAt;
use Lcobucci\JWT\Validation\Constraint\SignedWith;

return [
...
'bootstrap' => [
    [
        'class' => Bootstrap::class,
        'clientAuthUrl' => getenv('KEYCLOAK_AUTH_URL'),
        'clientIssuerUrl' => getenv('KEYCLOAK_ISSUER_URL'),
        'clientClientId' => getenv('KEYCLOAK_CLIENT'),
        'clientClientSecret' => getenv('KEYCLOAK_CLIENT_SECRET')
    ]
],
'components' => [
    'jwt' => [ // example
        'class' => Jwt::class,
        'signer' => Jwt::RS256,
        'signingKey' => [
            'key' => getenv('JWT_PUBLIC_KEY_FILE'),
            'method' => Jwt::METHOD_FILE,
        ],
        'verifyingKey' => [
            'key' => getenv('JWT_PUBLIC_KEY_FILE'),
            'method' => Jwt::METHOD_FILE,
        ],
        'validationConstraints' => function ($jwt) {
            $config = $jwt->getConfiguration();
            return [
                new SignedWith($config->signer(), $config->signingKey()),
                new IssuedBy(getenv('JWT_TOKEN_ISSUER')),
                new LooseValidAt(SystemClock::fromUTC()),
            ];
        }
    ],
     'tokenManager' => [
            'class' => TokenManager::class
     ]
],
'modules' => [
    'user' => [
        'enableRegistration' => true
    ]
]
...
];
```

After logging in to an account via social account login you can access to token like this

```php
use dmstr\tokenManager\components\TokenManager;

$token = Yii::$app->tokenManager->getToken();
```

#### Token attribute mapping

if you need to map attributes from within the token to "other" clientAttributes, this can be done via the `clientTokenAttributeMap` property.

Example: 
The user id in the token is named `sub` but should be mapped to the `id` attribute

```php
'bootstrap' => [
    [
        'class' => Bootstrap::class,
        'clientAuthUrl' => getenv('KEYCLOAK_AUTH_URL'),
        'clientIssuerUrl' => getenv('KEYCLOAK_ISSUER_URL'),
        'clientClientId' => getenv('KEYCLOAK_CLIENT'),
        'clientClientSecret' => getenv('KEYCLOAK_CLIENT_SECRET'),
        'clientTokenAttributeMap' => [
                'id' => 'sub'
         ],
    ]
],

```
