class AddForeignKeysToUsersInCourseBattleUser < ActiveRecord::Migration[7.1]
  def change
    if foreign_key_exists?(:course_battle_users, :user_id)
      remove_foreign_key :course_battle_users, column: :user_id
    end

    change_column :course_battle_users, :user_id, :bigint, if_exists: true
    unless foreign_key_exists?(:course_battle_users, :user_id)
      add_foreign_key :course_battle_users, :users, column: :user_id
    end
  end
end
