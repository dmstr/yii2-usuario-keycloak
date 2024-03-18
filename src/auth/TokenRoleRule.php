<?php

namespace dmstr\usuario\keycloak\auth;

use Yii;
use yii\authclient\BaseOAuth;
use yii\authclient\OAuthToken;
use yii\rbac\Item;
use yii\rbac\Rule;

/**
 * Rule which checks the group (or in $rbacRolesClaimName defined claim) and auto assignes it to the user.
 */
class TokenRoleRule extends Rule
{
    /**
     * Name of the auth client you want to use
     */
    public string $authClientId = 'keycloak';

    /**
     * Name of the jwt claim in which the rbac roles are included
     */
    public string $rbacRolesClaimName = 'groups';

    /**
     * @param string|int|null $user
     * @param Item $item
     * @param array $params
     *
     * @return bool
     */
    public function execute($user, $item, $params)
    {
        // Check if user is authenticated
        $identity = Yii::$app->getUser();
        if ($identity && !$identity->getIsGuest()) {
            /** @var BaseOAuth $client */
            $client = Yii::$app->authClientCollection->getClient($this->authClientId);
            $accessToken = $client->getAccessToken();
            // If access token is null, user is not authenticated via keycloak
            if ($accessToken instanceof OAuthToken) {
                // Extract groups from access token and check if rbac item is in list
                $roles = $accessToken->getParam($this->rbacRolesClaimName) ?? [];
                return in_array($item->name, $roles);
            }
        }
        return false;
    }
}

