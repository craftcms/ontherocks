<?php

namespace ontherocks\web\controllers;

use Craft;
use craft\elements\db\EntryQuery;
use craft\elements\Entry;
use craft\web\Controller;
use ontherocks\behaviors\EntryQueryBehavior;
use yii\web\Response;

class FilterRecipesController extends Controller
{
    protected $allowAnonymous = true;
    public $defaultAction = 'filter';

    public function actionFilter(): Response
    {
        $this->requirePostRequest();

        $search = Craft::$app->request->getBodyParam('search');
        $ingredient = Craft::$app->request->getBodyParam('ingredient');

        $recipes = Entry::find()
            ->section('recipes')
            ->search($search ?: null)
            ->ingredient($ingredient ?: null)
            ->all();

        return $this->renderTemplate('_includes/recipe-list', [
            'recipes' => $recipes,
        ]);
    }
}
