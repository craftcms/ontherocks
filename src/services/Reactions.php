<?php

namespace ontherocks\services;

use Craft;
use craft\db\Query;
use craft\elements\Entry;
use craft\helpers\ArrayHelper;
use LitEmoji\LitEmoji;
use ontherocks\behaviors\RecipeBehavior;
use yii\base\Component;

class Reactions extends Component
{
    /**
     * Loads reaction data for the given entries.
     *
     * @param Entry[]|RecipeBehavior[] $recipes
     */
    public function load(array $recipes)
    {
        $ids = ArrayHelper::getColumn($recipes, 'id');

        $results = (new Query())
            ->select(['reactions.recipeId', 'reactions.reaction', 'users.username'])
            ->from('{{%recipe_reactions}} reactions')
            ->innerJoin('{{%users}} users', '[[users.id]] = reactions.userId')
            ->where(['reactions.recipeId' => $ids])
            ->all();

        $reactionsByRecipe = [];

        foreach ($results as $result) {
            $emoji = LitEmoji::shortcodeToUnicode($result['reaction']);
            $reactionsByRecipe[$result['recipeId']][$emoji][] = $result['username'];
        }

        foreach ($recipes as $recipe) {
            $reactions = $reactionsByRecipe[$recipe->id] ?? [];
            $recipe->setReactions($reactions);
        }
    }
}
