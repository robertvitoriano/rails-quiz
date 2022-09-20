class AddForeignKeyToCourse < ActiveRecord::Migration[7.0]
  def change
    add_reference :courses, :course_types, references: :courses, foreign_key: true
  end
end
