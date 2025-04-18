<?php

namespace dmstr\usuario\keycloak\auth;

use Lcobucci\JWT\UnencryptedToken;
use Yii;
use yii\authclient\BaseOAuth;
use yii\base\InvalidConfigException;
use yii\helpers\VarDumper;
use yii\rbac\Item;
use yii\rbac\Rule;

/**
 * Rule which checks the group (or in $rbacRolesClaimName defined claim) and auto assigns it to the user.
 */
class TokenRoleRule extends Rule
{
    /**
     * Name of the auth client you want to use
     */
    public string $authClientId = 'keycloak';

    /**
     * Name of the jwt claim in which the rbac roles are included
     * NOTE: if this value gets changed: it ONLY affects new Rules created after it got updated.
     * Note2: Keycloak Default is realm_access.roles
     */
    public string $rbacRolesClaimName  = 'realm_access.roles';

    /**
     * JWT Tool component to parse JWT Tokens
     */
    public string $jwtComponent = 'jwt';

    /**
     * Auth Collection of Clients
     */
    public string $authCollectionComponent = 'authClientCollection';

    /**
     * Parameter name where the token is saved in the token data.
     * Note: tokenData comes from the client getAccessToken() method, which parses IDToken info and adds refresh and
     * access tokens as params to the data
     */
    public string $tokenParam = 'access_token';

    /**
     * @param string|int|null $user
     * @param Item $item
     * @param array $params
     *
     * @return bool
     * @throws InvalidConfigException
     */
    public function execute($user, $item, $params)
    {
        // Check if user is authenticated
        $identity = Yii::$app->getUser();
        if ($identity && !$identity->getIsGuest()) {
            // Get the AuthClient
            /** @var BaseOAuth $client */
            $client = Yii::$app->get($this->authCollectionComponent)->getClient($this->authClientId);
            // NOTE: oauth client returns the parsed info from *ID TOKEN* in this method and NOT the Access Token.
            // Access Token and Refresh Token are included here as Parameters
            $tokenData = $client?->getAccessToken();
            // Get the real access token from the Params
            $accessToken = $tokenData?->getParam($this->tokenParam);
            if($accessToken) {
                // The token here is actually a UnencryptedToken with Data Claims
                /** @var UnencryptedToken $parsedAccessToken */
                // Parse the real Access Token
                $parsedAccessToken = Yii::$app->get($this->jwtComponent)?->parse($accessToken);
                // Get the Roles from the Roles Claim
                $roles = $parsedAccessToken?->claims()?->get($this->rbacRolesClaimName);
                // If we don't have an Access Token or roles, directly return false
                if (!empty($roles)) {
                    // Check if the Role is in the list of Roles from the token
                    return in_array($item->name, $roles);
                }
            }
        }
        return false;
    }
}

