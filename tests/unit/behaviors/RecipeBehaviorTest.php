<?php /** @noinspection PassingByReferenceCorrectnessInspection */

namespace ontherocks\tests\unit\services;

use Craft;
use craft\elements\Entry;
use craft\helpers\ArrayHelper;
use ontherocks\behaviors\RecipeBehavior;

class RecipeBehaviorTest extends \Codeception\TestCase\Test
{
    /** @var RecipeBehavior $_recipe */
    private $_recipe;

    /**
     *
     */
    protected function _before()
    {
        // load a recipe
        $this->_recipe = Entry::findOne(9);
    }

    /**
     *
     */
    public function testGetIngredientsText()
    {
        $this->assertEquals("1 part gin\n2 parts tonic water", $this->_recipe->getIngredientsText());
        $this->assertEquals("- 1 part gin\n- 2 parts tonic water", $this->_recipe->getIngredientsText(true));
    }

    /**
     *
     */
    public function testGetDirectionsTest()
    {
        $this->assertEquals("Combine gin and tonic water in a highball glass over ice.\nGarnish with a lime.", $this->_recipe->getDirectionsText());
        $this->assertEquals("1. Combine gin and tonic water in a highball glass over ice.\n2. Garnish with a lime.", $this->_recipe->getDirectionsText(true));
    }

    /**
     * @throws \yii\db\Exception
     */
    public function testGetReactions()
    {
        // Todo: Fixture
        Craft::$app->getDb()->createCommand()->insert('{{%recipe_reactions}}', ['recipeId' => 9, 'userId' => 190, 'reaction' => ':heart:'], false)->execute();

        $this->assertCount(1, $this->_recipe->getReactions());
        $this->assertEquals('❤', ArrayHelper::firstKey($this->_recipe->getReactions()));
        $this->assertEquals('veronica', ArrayHelper::firstValue($this->_recipe->getReactions())[0]);

        Craft::$app->getDb()->createCommand()->delete('{{%recipe_reactions}}', ['recipeId' => 9, 'userId' => 190])->execute();
    }

    /**
     *
     */
    public function testSetReactions()
    {
        $reactions = [
            '❤' => [
               'veronica',
            ]
        ];

        $this->_recipe->setReactions($reactions);

        $this->assertEquals($reactions, $this->_recipe->getReactions());
    }
}
