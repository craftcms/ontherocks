<?php

namespace ontherocks\console\controllers;

use Craft;
use craft\base\Element;
use craft\elements\Entry;
use craft\helpers\Console;
use ontherocks\behaviors\RecipeBehavior;
use yii\console\Controller;
use yii\console\ExitCode;

class RecipesController extends Controller
{
    public $defaultAction = 'review';

    public function actionReview(): int
    {
        // get all the recipes that are waiting to be reviewed
        /** @var Entry[]|RecipeBehavior[] $recipes */
        $recipes = Entry::find()
            ->section('recipes')
            ->status(Element::STATUS_DISABLED)
            ->authorGroup('members')
            ->all();

        if (empty($recipes)) {
            $this->stdout(PHP_EOL . '✅ No recipes are pending review.' . PHP_EOL . PHP_EOL, Console::FG_GREEN);
            return ExitCode::OK;
        }

        $count = Console::ansiFormat(count($recipes), [Console::FG_YELLOW]);
        $this->stdout("There are $count recipes pending review:" . PHP_EOL . PHP_EOL);
        $options = [];

        foreach ($recipes as $i => $recipe) {
            $num = Console::ansiFormat(($i + 1) . ')', [Console::FG_YELLOW, Console::BOLD]);
            $title = $this->_userval("“{$recipe->title}”");
            $this->stdout("$num $title by {$recipe->author->name}" . PHP_EOL);
            $options[(string)($i + 1)] = $recipe->title;
        }

        $options['all'] = 'All recipes';
        $toReview = $this->select(PHP_EOL . 'Which ones do you want to review?', $options);
        $keys = $toReview === 'all' ? array_keys($recipes) : [$toReview - 1];

        foreach ($keys as $key) {
            $recipe = $recipes[$key];

            $this->stdout(PHP_EOL);
            $this->stdout($this->_field('Name', $recipe->title) . PHP_EOL . PHP_EOL);
            $this->stdout($this->_field('Ingredients', $recipe->getIngredientsText(true)) . PHP_EOL . PHP_EOL);
            $this->stdout($this->_field('Directions', $recipe->getDirectionsText(true)) . PHP_EOL . PHP_EOL);

            $description = '';
            $chunks = preg_split('/(<.*?>)/', $recipe->description, -1, PREG_SPLIT_DELIM_CAPTURE);
            foreach ($chunks as $i => $chunk) {
                $description .= Console::ansiFormat($chunk, [$i % 2 ? Console::FG_BLUE : Console::FG_CYAN]);
            }
            $this->stdout($this->_field('Description', $description) . PHP_EOL . PHP_EOL);

            if ($this->confirm('Look good?')) {
                $recipe->enabled = true;
                Craft::$app->elements->saveElement($recipe, false);
                $this->stdout(PHP_EOL . '✅ Recipe enabled' . PHP_EOL . PHP_EOL, Console::FG_GREEN);
            }
        }

        return ExitCode::OK;
    }

    private function _label($str): string
    {
        return Console::ansiFormat($str, [Console::FG_GREY, Console::BOLD]);
    }

    private function _userval($str): string
    {
        return Console::ansiFormat($str, [Console::FG_CYAN]);
    }

    private function _field($label, $val): string
    {
        return $this->_label(str_pad("$label:", 20, ' ', STR_PAD_LEFT)) . '  ' .
            $this->_userval(implode("\n" . str_repeat(' ', 22), explode("\n", $val)));
    }
}
