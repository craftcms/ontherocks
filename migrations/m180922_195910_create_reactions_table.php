<?php

namespace craft\contentmigrations;

use Craft;
use craft\db\Migration;

/**
 * m180922_195910_create_reactions_table migration.
 */
class m180922_195910_create_reactions_table extends Migration
{
    /**
     * @inheritdoc
     */
    public function safeUp()
    {
        $this->createTable('{{%recipe_reactions}}', [
            'id' => $this->primaryKey(),
            'recipeId' => $this->integer(),
            'userId' => $this->integer(),
            'reaction' => $this->string(),
        ]);

        $this->createIndex(null, '{{%recipe_reactions}}', ['recipeId', 'userId', 'reaction'], true);
        $this->addForeignKey(null, '{{%recipe_reactions}}', ['recipeId'], '{{%entries}}', ['id'], 'CASCADE');
        $this->addForeignKey(null, '{{%recipe_reactions}}', ['userId'], '{{%users}}', ['id'], 'CASCADE');
    }

    /**
     * @inheritdoc
     */
    public function safeDown()
    {
        echo "m180922_195910_create_reactions_table cannot be reverted.\n";
        return false;
    }
}
