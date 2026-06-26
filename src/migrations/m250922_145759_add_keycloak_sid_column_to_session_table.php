<?php

use yii\db\Migration;

/**
 * Handles adding columns to table `{{%session}}`.
 */
class m250922_145759_add_keycloak_sid_column_to_session_table extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function up()
    {
        $this->addColumn('{{%session}}', 'keycloak_sid', $this->string(255)->null());
        $this->createIndex('idx_keycloak_sid', '{{%session}}', 'keycloak_sid');
    }

    /**
     * {@inheritdoc}
     */
    public function down()
    {
        $this->dropIndex('idx_keycloak_sid', '{{%session}}');
        $this->dropColumn('{{%session}}', 'keycloak_sid');
    }
}
