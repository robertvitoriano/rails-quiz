class RemoveIsRightFromCourseQuestion < ActiveRecord::Migration[7.0]
  def change
    remove_column :course_questions, :is_right, :boolean
  end
end
