class CreateCourseQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :course_questions do |t|
      t.string :question_text
      t.boolean :is_right
      t.integer :course_id

      t.timestamps
    end
  end
end
