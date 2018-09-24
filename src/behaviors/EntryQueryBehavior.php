<?php

namespace ontherocks\behaviors;

use craft\elements\db\ElementQuery;
use craft\elements\db\EntryQuery;
use craft\elements\Entry;
use yii\base\Behavior;

/**
 * Class EntryQueryBehavior
 *
 * @property EntryQuery $owner
 */
class EntryQueryBehavior extends Behavior
{
    /**
     * @var int|null The ingredient ID that the recipes should have
     */
    public $ingredientId;

    /**
     * @inheritdoc
     */
    public function events()
    {
        return [
            ElementQuery::EVENT_AFTER_PREPARE => 'onAfterPrepare',
        ];
    }

    /**
     * @param int $value
     * @return EntryQuery
     */
    public function ingredientId(int $value): EntryQuery
    {
        $this->ingredientId = $value;
        return $this->owner;
    }

    /**
     * @param mixed $value
     * @return EntryQuery
     */
    public function ingredient($value): EntryQuery
    {
        if ($value instanceof Entry) {
            $this->ingredientId = $value->id;
        } else if ($value !== null) {
            $this->ingredientId = Entry::find()
                ->select('elements.id')
                ->section('ingredients')
                ->slug($value)
                ->scalar();
        } else {
            $this->ingredientId = null;
        }

        return $this->owner;
    }

    public function onAfterPrepare()
    {
        if ($this->ingredientId) {
            $this->owner->subQuery
                ->innerJoin('{{%supertableblocks}} blocks', '[[blocks.ownerId]] = [[elements.id]]')
                ->innerJoin('{{%relations}} rel', '[[rel.sourceId]] = [[blocks.id]]')
                ->andWhere(['rel.targetId' => $this->ingredientId]);
        }
    }
}
