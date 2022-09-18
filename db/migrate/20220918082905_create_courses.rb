class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.decimal :goal
      t.integer :course_type_id

      t.timestamps
    end
  end
end
