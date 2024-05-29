class AddForeignKeysToCourseBattleMessages < ActiveRecord::Migration[7.1]
  def change
    if foreign_key_exists?(:course_battle_messages, :user_id)
      remove_foreign_key :course_battle_messages, column: :user_id
    end
    change_column :course_battle_messages, :user_id, :bigint
    add_foreign_key :course_battle_messages, :users, column: :user_id
  end
end
