<?php

namespace ontherocks\web;

use ontherocks\Module;

class TwigExtension extends \Twig_Extension
{
    public function getFunctions()
    {
        return [
            new \Twig_SimpleFunction('loadReactions', [Module::getInstance()->reactions, 'load']),
        ];
    }
}
