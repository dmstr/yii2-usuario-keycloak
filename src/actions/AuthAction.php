<?php

namespace dmstr\usuario\keycloak\actions;

use yii\authclient\Collection;
use yii\helpers\HtmlPurifier;
use yii\web\NotFoundHttpException;
use Yii;

class AuthAction extends \yii\authclient\AuthAction
{
    public string $idp_hint_param;

    /**
     * Runs the action.
     */
    public function run()
    {
        $clientId = $this->getClientId();
        if (!empty($clientId)) {
            /* @var $collection Collection */
            $collection = Yii::$app->get($this->clientCollection);
            if (!$collection->hasClient($clientId)) {
                throw new NotFoundHttpException("Unknown auth client '{$clientId}'");
            }
            $client = $collection->getClient($clientId);
            return $this->auth($client, [$this->idp_hint_param => HtmlPurifier::process(Yii::$app->getRequest()->get($this->idp_hint_param))]);
        }

        throw new NotFoundHttpException();
    }
}
