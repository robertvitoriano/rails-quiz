class AddDeleteCascadeToQuestionCourseForeignKey < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :course_questions, :courses, on_delete: :cascade
  end
end
