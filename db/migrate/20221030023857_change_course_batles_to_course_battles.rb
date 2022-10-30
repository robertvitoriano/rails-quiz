class ChangeCourseBatlesToCourseBattles < ActiveRecord::Migration[7.0]
  def change
    rename_table :course_batles, :course_battles
  end
end
