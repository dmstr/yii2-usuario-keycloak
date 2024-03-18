<?php
/**
 * @var $url string
 */

// just do a very simple redirect, as the default has some broken JS magic.
Yii::$app->response->redirect($url);
