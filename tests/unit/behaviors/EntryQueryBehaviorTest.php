<?php /** @noinspection PassingByReferenceCorrectnessInspection */

namespace ontherocks\tests\unit\services;

use craft\elements\db\ElementQuery;
use craft\elements\db\EntryQuery;
use craft\elements\Entry;

class EntryQueryBehaviorTest extends \Codeception\TestCase\Test
{
    /** @var EntryQuery $_entryQuery */
    private $_entryQuery;

    /**
     *
     */
    protected function _before()
    {
        // create an entry query
        $this->_entryQuery = Entry::find();
    }

    /**
     *
     */
    public function testEvents()
    {
        $this->assertEquals(true, array_key_exists(ElementQuery::EVENT_AFTER_PREPARE, $this->_entryQuery->events()));
    }

    /**
     *
     */
    public function testIngredientId()
    {
        $this->assertInstanceOf(EntryQuery::class, $this->_entryQuery->ingredientId(4));
        $this->assertEquals(4, $this->_entryQuery->ingredientId);
    }

    /**
     *
     */
    public function testIngredient()
    {
        $this->assertInstanceOf(EntryQuery::class, $this->_entryQuery->ingredient(null));
        $this->assertNull($this->_entryQuery->ingredientId, $this->_entryQuery->ingredient(null));
        $this->_entryQuery->ingredient('gin');
        $this->assertEquals(4, $this->_entryQuery->ingredientId);
        $ingredient = Entry::findOne(4);
        $this->_entryQuery->ingredient($ingredient);
        $this->assertEquals(4, $this->_entryQuery->ingredientId);
    }

    /**
     *
     */
    public function testOnAfterPrepare()
    {
        $this->_entryQuery->ingredientId = 4;
        $results = $this->_entryQuery->all();

        $this->assertCount(2, $results);
        $this->assertEquals(105, $results[0]->id);
        $this->assertEquals(9, $results[1]->id);
    }
}
