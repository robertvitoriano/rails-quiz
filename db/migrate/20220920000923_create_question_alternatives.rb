class CreateQuestionAlternatives < ActiveRecord::Migration[7.0]
  def change
    create_table :question_alternatives do |t|
      t.string :alternative_text
      t.boolean :is_right
      t.integer :course_question_id

      t.timestamps
    end
  end
end
