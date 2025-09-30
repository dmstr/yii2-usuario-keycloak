<?php

namespace dmstr\usuario\keycloak\components;

use Da\User\Component\AuthDbManagerComponent;
use dmstr\usuario\keycloak\auth\TokenRoleRule;
use Yii;
use yii\rbac\Item;

class AuthDbManager extends AuthDbManagerComponent
{

    /**
     * @inheritdoc
     */
    public function checkAccess($userId, $permissionName, $params = [])
    {
        // using the token role rule to check if permission name is in roles claim of the user
        $rbacRule = Yii::createObject(TokenRoleRule::class);
        $item = Yii::createObject(Item::class, ['config' => ['name' => $permissionName]]);

        if ($rbacRule->execute($userId, $item, $params)) {
            return true;
        }

        return parent::checkAccess($userId, $permissionName, $params);
    }
}
