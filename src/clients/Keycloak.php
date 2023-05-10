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

    public $clientTokenAttributeMap = [];

    /**
     * {@inheritdoc}
     */
    protected function initUserAttributes()
    {
        $token = $this->getAccessToken()->getToken();
        $loaded = $this->loadJws($token);

        if (is_array($this->clientTokenAttributeMap)) {
            foreach ($this->clientTokenAttributeMap as $key => $src) {
                if (empty($loaded[$key])) {
                    $loaded[$key] = $loaded[$src] ?? null;
                }
            }
        }
        return $loaded;
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
