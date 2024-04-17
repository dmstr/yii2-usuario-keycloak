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
                $roles = (array)$this->getClaim($this->rbacRolesClaimName, $accessToken);
                return in_array($item->name, $roles);
            }
        }
        return false;
    }

    /**
     * Get claims from the token.
     * For nested claims, IE: "groups": ["a" : ["B", "C"]] use dot notation for $name: groups.a
     * @param string $name
     * @param $default
     * @return mixed
     */
    protected function getClaim(string $name, OAuthToken $accessToken)
    {
        // split name into separate parts
        $parts = explode('.', $name);

        // check if there is at least one item
        $baseName = $parts[0] ?? null;
        if ($baseName === null) {
            return null;
        }

        // remove first part because it is saved in $baseName
        unset($parts[0]);

        // set this as base value
        $baseValue = $accessToken->getParam($baseName);

        // iterate over the rest of the parts
        foreach ($parts as $part) {
            // check if key exists. If not return default.
            if (!isset($baseValue[$part])) {
                return null;
            }
            // check if value is array to continue. If not return value
            if (!is_array($baseValue[$part])) {
                return $baseValue;
            }
            $baseValue = $baseValue[$part];
        }
        // return the value
        return $baseValue;
    }
}

