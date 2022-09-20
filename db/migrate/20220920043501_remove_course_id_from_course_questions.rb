class RemoveCourseIdFromCourseQuestions < ActiveRecord::Migration[7.0]
  def change
    remove_column :course_questions, :course_id, :integer
  end
end
