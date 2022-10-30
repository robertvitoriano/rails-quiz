class ChangeCourseBatleUsersToCourseBattleUsers < ActiveRecord::Migration[7.0]
  def change
    rename_table :course_batle_users, :course_battle_users
  end
end
