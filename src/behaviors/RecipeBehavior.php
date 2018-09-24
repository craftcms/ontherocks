<?php

namespace ontherocks\behaviors;

use craft\elements\Entry;
use ontherocks\Module;
use verbb\supertable\elements\SuperTableBlockElement;
use yii\base\Behavior;

/**
 * Class RecipeBehavior
 *
 * @property Entry $owner
 */
class RecipeBehavior extends Behavior
{
    private $_reactions;

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

    /**
     * Returns a list of reactions for the recipe, in the format of `[':reaction:' => [usernames]]`.
     *
     * @return array
     */
    public function getReactions(): array
    {
        if ($this->_reactions === null) {
            Module::getInstance()->reactions->load([$this->owner]);
        }

        return $this->_reactions;
    }

    /**
     * Sets the reactions for a recipe
     * @param array $reactions
     */
    public function setReactions(array $reactions)
    {
        // sort the reactions by most-to-least popular
        $reactionCounts = [];
        foreach ($reactions as $users) {
            $reactionCounts[] = count($users);
        }
        array_multisort($reactions, $reactionCounts, SORT_DESC, SORT_NUMERIC);

        $this->_reactions = $reactions;
    }
}
