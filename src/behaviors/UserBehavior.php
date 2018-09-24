<?php

namespace ontherocks\behaviors;

use craft\elements\db\EntryQuery;
use craft\elements\Entry;
use craft\elements\User;
use yii\base\Behavior;

/**
 * Class UserBehavior
 *
 * @property User $owner
 * @property EntryQuery $recipes
 */
class UserBehavior extends Behavior
{
    public function getRecipes(): EntryQuery
    {
        if (!$this->owner->id) {
            // just return a query that is doomed to fail
            return Entry::find()
                ->id(false);
        }

        return Entry::find()
            ->section('recipes')
            ->authorId($this->owner->id);
    }
}
