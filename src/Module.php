<?php

namespace ontherocks;

use Craft;
use craft\base\Element;
use craft\elements\db\EntryQuery;
use craft\elements\Entry;
use craft\elements\User;
use craft\events\DefineBehaviorsEvent;
use craft\events\RegisterEmailMessagesEvent;
use craft\models\SystemMessage;
use craft\services\SystemMessages;
use ontherocks\behaviors\EntryQueryBehavior;
use ontherocks\behaviors\RecipeBehavior;
use ontherocks\behaviors\UserBehavior;
use yii\base\Event;

/**
 * Custom module class.
 *
 * This class will be available throughout the system via:
 * `Craft::$app->getModule('my-module')`.
 *
 * You can change its module ID ("my-module") to something else from
 * config/app.php.
 *
 * If you want the module to get loaded on every request, uncomment this line
 * in config/app.php:
 *
 *     'bootstrap' => ['my-module']
 *
 * Learn more about Yii module development in Yii's documentation:
 * http://www.yiiframework.com/doc-2.0/guide-structure-modules.html
 */
class Module extends \yii\base\Module
{
    const MESSAGE_KEY_RECIPE_ISSUE = 'ontherocks_recipe_issue';

    /**
     * Initializes the module.
     */
    public function init()
    {
        // Set a @modules alias pointed to the modules/ directory
        Craft::setAlias('@ontherocks', __DIR__);

        // Set the controllerNamespace based on whether this is a console or web request
        if (Craft::$app->request->isConsoleRequest) {
            $this->controllerNamespace = __NAMESPACE__ . '\\console\\controllers';
        } else {
            $this->controllerNamespace = __NAMESPACE__ . '\\web\\controllers';
        }

        parent::init();

        // define entry query behavior
        Event::on(EntryQuery::class, EntryQuery::EVENT_DEFINE_BEHAVIORS, function(DefineBehaviorsEvent $event) {
            $event->behaviors[$this->id] = EntryQueryBehavior::class;
        });

        // define recipe behavior
        Event::on(Entry::class, Element::EVENT_DEFINE_BEHAVIORS, function(DefineBehaviorsEvent $event) {
            /** @var Entry $entry */
            $entry = $event->sender;

            if ($entry->id && $entry->section->handle === 'recipes') {
                $event->behaviors["$this->id.recipe"] = RecipeBehavior::class;
            }
        });

        // define user behavior
        Event::on(User::class, Element::EVENT_DEFINE_BEHAVIORS, function(DefineBehaviorsEvent $event) {
            $event->behaviors[$this->id] = UserBehavior::class;
        });

        // register custom system message
        Event::on(SystemMessages::class, SystemMessages::EVENT_REGISTER_MESSAGES, function(RegisterEmailMessagesEvent $e) {
            $e->messages[] = new SystemMessage([
                'key' => self::MESSAGE_KEY_RECIPE_ISSUE,
                'heading' => 'When someone reports an issue with a recipe:',
                'subject' => 'Issue reported for {{ recipe.title }}',
                'body' => file_get_contents(Craft::getAlias('@ontherocks/emails/report.txt')),
            ]);
        });
    }
}
