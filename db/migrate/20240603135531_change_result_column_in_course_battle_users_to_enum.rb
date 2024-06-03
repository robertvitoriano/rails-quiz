class ChangeResultColumnInCourseBattleUsersToEnum < ActiveRecord::Migration[7.1]
  def change
    change_column :course_battle_users, :result, "enum('won','lost')", null: true
  end
end
