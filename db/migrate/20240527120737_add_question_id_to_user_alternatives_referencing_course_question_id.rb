class AddQuestionIdToUserAlternativesReferencingCourseQuestionId < ActiveRecord::Migration[7.1]
  def change
    remove_column :user_alternatives, :question_id, :binary
    add_column :user_alternatives, :question_id, :bigint, null: false
    add_foreign_key :user_alternatives, :course_questions, column: :question_id
  end
end
