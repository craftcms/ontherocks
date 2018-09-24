<?php

namespace ontherocks\web\controllers;

use Craft;
use craft\elements\Entry;
use craft\web\Controller;
use ontherocks\Module;
use yii\web\BadRequestHttpException;

class ReportController extends Controller
{
    public $defaultAction = 'submit';

    public function actionSubmit()
    {
        $id = Craft::$app->request->getRequiredBodyParam('id');
        $issue = Craft::$app->request->getRequiredBodyParam('issue');

        $entry = Entry::find()
            ->section('recipes')
            ->id($id)
            ->one();

        // make sure it exists
        if (!$entry) {
            throw new BadRequestHttpException("No recipe exists with the ID $id.");
        }

        // send the email
        $mailer = Craft::$app->getMailer();

        $mailer
            ->composeFromKey(Module::MESSAGE_KEY_RECIPE_ISSUE, [
                'recipe' => $entry,
                'issue' => $issue,
            ])
            ->setFrom($mailer->from)
            ->setTo(getenv('RECIPE_ISSUE_RECIPIENT'))
            ->send();

        Craft::$app->session->setNotice('Your issue has been sent. Thanks for reporting!');
        return $this->redirectToPostedUrl();
    }
}
