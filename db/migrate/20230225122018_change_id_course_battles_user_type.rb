class ChangeIdCourseBattlesUserType < ActiveRecord::Migration[7.0]
  def change
    change_column :course_battle_users, :course_battle_id, :binary, limit: 36, null: false
  end
end
