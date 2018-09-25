<?php
namespace ontherocks\tests\unit\services;

use craft\elements\db\EntryQuery;
use craft\elements\User;
use ontherocks\behaviors\UserBehavior;

class UserBehaviorTest extends \Codeception\TestCase\Test
{
    /** @var UserBehavior $_user */
    private $_user;

    protected function _before()
    {
        // load a user
        $this->_user = User::findOne(190);
    }

    /**
     *
     */
    public function testGetRecipes()
    {
        /** @noinspection UnnecessaryAssertionInspection */
        $this->assertInstanceOf(EntryQuery::class, $this->_user->getRecipes());
        $this->assertCount(3, $this->_user->getRecipes()->all());

        $this->_user->owner->id = null;
        $this->assertEmpty($this->_user->getRecipes()->all());
    }
}
