<?php

namespace dmstr\usuario\keycloak\helpers;

use Yii;
use yii\caching\CacheInterface;
use yii\httpclient\Client;

class KeycloakHelper
{

    /**
     * Returns the public key from the issuer url. E.g.: http://keycloak:8080/realms/your-realm
     */
    public static function publicKeyFromIssuer(string $issuerUrl): ?string
    {
        $cache = Yii::$app->getCache();
        // Check if cache component does exist
        if ($cache instanceof CacheInterface) {
            $publicKey = $cache->getOrSet(__CLASS__ . '.publicKey', function () use ($issuerUrl) {
                // Get public key from issuer url. Cache it if it exists. If there is an error or invalid public key. Do not cache
                $publicKey = self::fetchPublicKeyFromIssuer($issuerUrl);
                if (is_string($publicKey)) {
                    return $publicKey;
                }
                return false;
            }, 3600);

            if (is_string($publicKey)) {
                return $publicKey;
            }
            return null;
        }
        // If cache component does not exist. Fetch key directly
        return self::fetchPublicKeyFromIssuer($issuerUrl);

    }

    protected static function fetchPublicKeyFromIssuer(string $issuerUrl): ?string
    {
        $client = new Client([
            'baseUrl' => $issuerUrl
        ]);

        $response = $client->get('')->send();

        if ($response->getIsOk()) {
            $publicKeyContent = $response->getData()['public_key'] ?? null;
        } else {
            $publicKeyContent = null;
        }

        if (!empty($publicKeyContent)) {
            // Build public key in format needed by lombucci package
            $publicKey = '-----BEGIN PUBLIC KEY-----' . PHP_EOL . $publicKeyContent . PHP_EOL . '-----END PUBLIC KEY-----';
        } else {
            $publicKey = null;
        }

        return $publicKey;
    }
}
