<?php

namespace dmstr\usuario\keycloak\clients;

use Da\User\Contracts\AuthClientInterface;
use yii\authclient\OpenIdConnect;
use yii\web\HttpException;

/**
 * --- PROPERTIES ---
 *
 * @author Elias Luhr
 */
class Keycloak extends OpenIdConnect implements AuthClientInterface
{
    /**
     * {@inheritdoc}
     */
    protected function initUserAttributes()
    {
        $token = $this->getAccessToken()->getToken();
        return $this->loadJws($token);
    }

    /**
     * {@inheritdoc}
     */
    public function getEmail()
    {
        return $this->getUserAttributes()['email'] ?? null;
    }

    /**
     * {@inheritdoc}
     */
    public function getUsername()
    {
        // returns the e-mail as it corresponds with the username
        return $this->getEmail();
    }

    /**
     * @throws HttpException
     * @return mixed
     */
    public function getRealmAccess(): mixed
    {
        $accessToken = $this->getAccessToken();
        if ($accessToken) {
            $token = $accessToken->getToken();
            return $this->loadJws($token)['realm_access'] ?? null;
        }
        return null;
    }
}
