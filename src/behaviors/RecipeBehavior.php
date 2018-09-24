<?php

namespace ontherocks\behaviors;

use craft\elements\Entry;
use verbb\supertable\elements\SuperTableBlockElement;
use yii\base\Behavior;

/**
 * Class RecipeBehavior
 *
 * @property Entry $owner
 */
class RecipeBehavior extends Behavior
{
    public function getIngredientsText(): string
    {
        $lines = [];
        foreach ($this->owner->ingredients->all() as $ingredient) {
            /** @var SuperTableBlockElement $ingredient */
            $lines[] = $ingredient->label;
        }
        return implode("\n", $lines);
    }

    public function getDirectionsText(): string
    {
        $lines = [];
        foreach ($this->owner->directions as $direction) {
            $lines[] = $direction['step'];
        }
        return implode("\n", $lines);
    }
}
