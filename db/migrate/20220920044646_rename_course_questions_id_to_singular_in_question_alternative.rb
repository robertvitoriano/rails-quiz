class RenameCourseQuestionsIdToSingularInQuestionAlternative < ActiveRecord::Migration[7.0]
  def change
    rename_column :question_alternatives, :course_questions_id, :course_question_id
  end
end
