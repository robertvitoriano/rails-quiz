class AddForeignKeyToCourseIdInCourseBattles < ActiveRecord::Migration[7.1]
  def change
    change_column :course_battles, :course_id, :bigint
    add_foreign_key :course_battles, :courses, column: :course_id
  end
end
