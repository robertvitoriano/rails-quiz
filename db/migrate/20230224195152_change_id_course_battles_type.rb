class ChangeIdCourseBattlesType < ActiveRecord::Migration[7.0]
  def change
    change_column :course_battles, :id, :binary, limit: 36, null: false
  end
end
