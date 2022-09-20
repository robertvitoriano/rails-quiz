class AddConstraintNotNullToCoursesIdForeignkey < ActiveRecord::Migration[7.0]
  def change
    change_column_null :course_questions, :courses_id, false
  end
end
