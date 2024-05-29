class CleanInvalidUserReferencesInCourseBattleUsers < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      DELETE FROM course_battle_users
      WHERE user_id IS NOT NULL
      AND user_id NOT IN (SELECT id FROM users);
    SQL
  end

  def down
    # This migration is irreversible because the deleted records can't be restored.
    raise ActiveRecord::IrreversibleMigration
  end
end
