class AddForeignKeyToCourseIdInCourseQuestios < ActiveRecord::Migration[7.0]
  def change
    add_reference :course_questions, :courses, references: :courses, foreign_key: true
  end
end
