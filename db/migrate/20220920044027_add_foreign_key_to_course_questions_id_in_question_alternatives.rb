class AddForeignKeyToCourseQuestionsIdInQuestionAlternatives < ActiveRecord::Migration[7.0]
  def change
    add_reference :question_alternatives, :course_questions, references: :course_questions, foreign_key: true
  end
end
