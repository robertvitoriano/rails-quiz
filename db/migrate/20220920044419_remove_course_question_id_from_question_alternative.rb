class RemoveCourseQuestionIdFromQuestionAlternative < ActiveRecord::Migration[7.0]
  def change
    remove_column :question_alternatives, :course_question_id, :integer
  end
end
