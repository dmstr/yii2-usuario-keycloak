<?php

namespace dmstr\usuario\keycloak\traits;

trait AuditLogTrait
{
    public bool $debug = false;

    protected function logException(Exception $exception): void
    {
        if (Yii::$app->hasModule('audit')) {
            Yii::$app->getModule('audit')->exception($exception);
        } else {
            Yii::error($exception->getMessage());
        }
    }

    protected function logInfo(mixed $data): void
    {
        if (Yii::$app->hasModule('audit')) {
            Yii::$app->getModule('audit')->data('info', $data);
        } else {
            Yii::info($data);
        }
    }

    protected function logError(string $message): void
    {
        if (Yii::$app->hasModule('audit')) {
            Yii::$app->getModule('audit')->errorMessage($message);
        } else {
            Yii::error($message);
        }
    }

    protected function logDebug(string $message): void
    {
        if ($this->debug) {
            if (Yii::$app->hasModule('audit')) {
                Yii::$app->getModule('audit')->data('debug', $message);
            } else {
                Yii::debug($message);
            }
        }
    }
}
