<?php

namespace ontherocks\web\controllers;

use Craft;
use craft\base\Element;
use craft\elements\Entry;
use craft\fields\Table;
use craft\helpers\ArrayHelper;
use craft\web\Controller;
use ontherocks\behaviors\RecipeBehavior;
use ontherocks\controllers\nul;
use verbb\supertable\fields\SuperTableField;
use verbb\supertable\models\SuperTableBlockTypeModel;
use yii\web\BadRequestHttpException;
use yii\web\ForbiddenHttpException;
use yii\web\Response;
use yii\web\ServerErrorHttpException;

class RecipesController extends Controller
{
    /**
     * @throws BadRequestHttpException
     * @throws ForbiddenHttpException
     * @return Response|nul
     */
    public function actionSave()
    {
        $this->requirePostRequest();

        $user = Craft::$app->user->getIdentity();
        $id = Craft::$app->request->getBodyParam('id');
        $name = Craft::$app->request->getBodyParam('name');
        $ingredients = Craft::$app->request->getBodyParam('ingredients');
        $directions = Craft::$app->request->getBodyParam('directions');
        $description = Craft::$app->request->getBodyParam('description');
        $glass = Craft::$app->request->getBodyParam('glass');

        if ($id) {
            $entry = Entry::find()
                ->section('recipes')
                ->id($id)
                ->anyStatus()
                ->one();

            // make sure it exists
            if (!$entry) {
                throw new BadRequestHttpException("No recipe exists with the ID $id.");
            }

            // make sure the current user is the author
            if ($entry->authorId != $user->id) {
                throw new ForbiddenHttpException("Recipe $id does not belong to you.");
            }

            // ensure that the slug gets regenerated based on the title
            $entry->slug = null;
        } else {
            // create a new entry
            $entry = new Entry();
            $entry->attachBehavior("{$this->module->id}.recipe", RecipeBehavior::class);

            // set the boilerplate stuff on it
            $section = Craft::$app->sections->getSectionByHandle('recipes');
            $entryType = $section->getEntryTypes()[0];
            $entry->sectionId = $section->id;
            $entry->typeId = $entryType->id;
            $entry->authorId = $user->id;
            $entry->enabled = false;
        }

        // set the title & custom fields
        $entry->title = $name;
        $entry->setFieldValues([
            'ingredients' => $this->_parseIngredients($ingredients),
            'directions' => $this->_parseDirections($directions),
            'description' => $description,
            'glass' => $glass,
        ]);

        // validate as live, even though it isn't
        $entry->setScenario(Element::SCENARIO_LIVE);
        if (!$entry->validate()) {
            // send the entry back to the template
            Craft::$app->session->setError('Couldn’t save the recipe.');
            Craft::$app->getUrlManager()->setRouteParams([
                'recipe' => $entry
            ]);
            return null;
        }

        // now save the entry (but no need to re-validate)
        if (!Craft::$app->elements->saveElement($entry)) {
            // this shouldn't ever happen
            Craft::warning("Couldn't save recipe due to unexpected error: \n" . implode("\n", $entry->getErrorSummary(true)), __METHOD__);
            throw new ServerErrorHttpException('An internal server error occurred.');
        }

        // success!
        if ($id) {
            Craft::$app->session->setNotice('Recipe saved.');
        } else {
            Craft::$app->session->setNotice('Recipe submitted.');
        }

        return $this->redirectToPostedUrl($entry);
    }

    private function _parseIngredients(string $ingredients): array
    {
        // split the post value into individual lines
        $lines = array_filter(preg_split('/[\r\n]/', $ingredients));

        // get the Super Table field
        /** @var SuperTableField $field */
        $field = Craft::$app->fields->getFieldByHandle('ingredients');

        // find the ID of the block type
        /** @var SuperTableBlockTypeModel $blockType */
        $blockType = $field->getBlockTypes()[0];
        $blockTypeId = $blockType->id;

        // start building out the field value
        $fieldValue = [];

        foreach ($lines as $key => $line) {
            $fieldValue["new$key"] = [
                'type' => $blockTypeId,
                'fields' => [
                    'label' => $line,
                ],
            ];
        }

        return $fieldValue;
    }

    private function _parseDirections(string $directions): array
    {
        // split the post value into individual lines
        $lines = array_filter(preg_split('/[\r\n]/', $directions));

        // get the Table field
        /** @var Table $field */
        $field = Craft::$app->fields->getFieldByHandle('directions');

        // find the ]ID of the Step column
        $columnId = ArrayHelper::firstKey($field->columns);

        // start building out the field value
        $fieldValue = [];

        foreach ($lines as $key => $line) {
            $fieldValue[] = [
                $columnId => $line,
            ];
        }

        return $fieldValue;
    }
}
