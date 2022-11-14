class AddDeleteCascadeToQuestionAlternatives < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :question_alternatives, :course_questions, on_delete: :cascade
  end
end
