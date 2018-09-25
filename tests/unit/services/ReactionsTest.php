<?php
namespace ontherocks\tests\unit\services;

use Craft;
use craft\elements\Entry;
use craft\helpers\ArrayHelper;
use ontherocks\behaviors\RecipeBehavior;
use ontherocks\services\Reactions;

;

class ReactionsTest extends \Codeception\TestCase\Test
{
    /* @var Entry[]|RecipeBehavior[] $_recipes */
    private $_recipes;

    /**
     *
     */
    protected function _before()
    {
        $this->_recipes = Entry::find()->id([9, 13])->all();
    }

    /**
     *
     */
    public function testLoad()
    {
        // Todo: Fixture
        foreach ($this->_recipes as $recipe) {
            Craft::$app->getDb()->createCommand()->insert('{{%recipe_reactions}}', ['recipeId' => $recipe->id, 'userId' => 190, 'reaction' => ':heart:'], false)->execute();
        }

        $reactionsService = new Reactions();
        $reactionsService->load($this->_recipes);

        foreach ($this->_recipes as $recipe) {
            $this->assertEquals('❤', ArrayHelper::firstKey($recipe->getReactions()));
            $this->assertEquals('veronica', ArrayHelper::firstValue($recipe->getReactions())[0]);
        }

        foreach ($this->_recipes as $recipe) {
            Craft::$app->getDb()->createCommand()->delete('{{%recipe_reactions}}', ['recipeId' => $recipe->id, 'userId' => 190])->execute();
        }
    }
}
