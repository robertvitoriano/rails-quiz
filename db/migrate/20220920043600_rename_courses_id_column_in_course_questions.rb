class RenameCoursesIdColumnInCourseQuestions < ActiveRecord::Migration[7.0]
  def change
    rename_column :course_questions, :courses_id, :course_id

  end
end
