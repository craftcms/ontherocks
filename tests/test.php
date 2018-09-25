<?php

use craft\helpers\ArrayHelper;
use craft\services\Config;

$_SERVER['REMOTE_ADDR'] = '1.1.1.1';
$_SERVER['REMOTE_PORT'] = 654321;

$basePath = dirname(__DIR__);

$srcPath = $basePath.'/src';
$vendorPath = $basePath.'/vendor';
$craftcmsPath = $vendorPath.'/craftcms/cms/src';

// Load the config
$config = ArrayHelper::merge(
    [
        'modules' => [
            'on-the-rocks' => \ontherocks\Module::class,
        ],
        'bootstrap' => ['on-the-rocks'],
        'components' => [
            'config' => [
                'class' => Config::class,
                'configDir' => $basePath.'/config',
                'env' => 'test',
                'appDefaultsDir' => $craftcmsPath.'/config/defaults',
            ],
        ],
    ],
    require $craftcmsPath.'/config/app.php',
    require $craftcmsPath.'/config/app.web.php'
);

$config['vendorPath'] = $vendorPath;

$config = ArrayHelper::merge($config, [
    'components' => [
        'sites' => [
            'currentSite' => 'default'
        ]
    ],
]);

return ArrayHelper::merge($config, [
    'class' => craft\web\Application::class,
    'id'=>'on-the-rocks',
]);
