<?php

define('YII_ENV', 'test');
define('CRAFT_ENVIRONMENT', 'test');

// Use the current installation of Craft
define('CRAFT_STORAGE_PATH', __DIR__.'/../storage');
define('CRAFT_TEMPLATES_PATH', __DIR__.'/../templates');
define('CRAFT_CONFIG_PATH', __DIR__.'/../config');
define('CRAFT_VENDOR_PATH', __DIR__.'/../vendor');

$devMode = true;

$vendorPath = realpath(CRAFT_VENDOR_PATH);
$basePath = __DIR__.'/../';

$configPath = realpath($basePath.'/config');
$contentMigrationsPath = realpath($basePath.'/migrations');
$storagePath = realpath($basePath.'/storage');
$templatesPath = realpath($basePath.'/templates');
$translationsPath = realpath($basePath.'/tests/_craft/translations');

// Load dotenv?
if (file_exists(__DIR__.'/.env')) {
    (new Dotenv\Dotenv(__DIR__))->load();
}

// Log errors to craft/storage/logs/phperrors.log

ini_set('log_errors', 1);
ini_set('error_log', $storagePath.'/logs/phperrors.log');

error_reporting(E_ALL);
ini_set('display_errors', 1);
defined('YII_DEBUG') || define('YII_DEBUG', true);
defined('YII_ENV') || define('YII_ENV', 'dev');
defined('CRAFT_ENVIRONMENT') || define('CRAFT_ENVIRONMENT', '');

defined('CURLOPT_TIMEOUT_MS') || define('CURLOPT_TIMEOUT_MS', 155);
defined('CURLOPT_CONNECTTIMEOUT_MS') || define('CURLOPT_CONNECTTIMEOUT_MS', 156);

// Load the files
$srcPath = dirname(__DIR__).'/src';
require $vendorPath.'/yiisoft/yii2/Yii.php';
$craftSrcPath = $vendorPath.'/craftcms/cms/src';
require $craftSrcPath.'/Craft.php';
$libPath = $vendorPath.'/craftcms/cms/lib';

// Set aliases

Craft::setAlias('@lib', $libPath);
Craft::setAlias('@craft', $craftSrcPath);
Craft::setAlias('@craftnet', $srcPath);
Craft::setAlias('@config', $configPath);
Craft::setAlias('@contentMigrations', $contentMigrationsPath);
Craft::setAlias('@storage', $storagePath);
Craft::setAlias('@templates', $templatesPath);
Craft::setAlias('@translations', $translationsPath);
