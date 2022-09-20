class AddCourseTypeForeignKeyToCourse < ActiveRecord::Migration[7.0]
  def change
    add_reference :course, :course_type, index: true
    add_foreign_key :course, :course_type
  end
end