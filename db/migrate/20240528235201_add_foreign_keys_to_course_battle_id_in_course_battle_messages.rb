class AddForeignKeysToCourseBattleIdInCourseBattleMessages < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :course_battle_messages, :course_battles, column: :course_battle_id
  end
end
