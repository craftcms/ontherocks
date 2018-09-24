<?php

namespace ontherocks\web\controllers;

use Craft;
use craft\elements\Entry;
use craft\web\Controller;
use LitEmoji\LitEmoji;
use ontherocks\Module;
use yii\web\BadRequestHttpException;

class ReactionsController extends Controller
{
    public function actionAdd()
    {
        $this->requirePostRequest();
        $recipeId = Craft::$app->request->getRequiredBodyParam('recipeId');
        $reaction = Craft::$app->request->getRequiredBodyParam('reaction');
        $reaction = LitEmoji::unicodeToShortcode($reaction);

        Craft::$app->db->createCommand()
            ->upsert('{{%recipe_reactions}}',
                [
                    'recipeId' => $recipeId,
                    'userId' => Craft::$app->user->id,
                    'reaction' => $reaction,
                ], [
                    'recipeId' => $recipeId,
                ], [], false)
            ->execute();
    }

    public function actionRemove()
    {
        $this->requirePostRequest();
        $recipeId = Craft::$app->request->getRequiredBodyParam('recipeId');
        $reaction = Craft::$app->request->getRequiredBodyParam('reaction');
        $reaction = LitEmoji::unicodeToShortcode($reaction);

        Craft::$app->db->createCommand()
            ->delete('{{%recipe_reactions}}',
                [
                    'recipeId' => $recipeId,
                    'userId' => Craft::$app->user->id,
                    'reaction' => $reaction,
                ])
            ->execute();
    }
}
