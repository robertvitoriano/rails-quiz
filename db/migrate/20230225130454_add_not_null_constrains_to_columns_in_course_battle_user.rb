class AddNotNullConstrainsToColumnsInCourseBattleUser < ActiveRecord::Migration[7.0]
  def change
    change_column_null :course_battle_users, :user_id, false
    change_column_null :course_battle_users, :course_battle_id, false
  end
end
