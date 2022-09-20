class RemoveCourseTypeIdFromCourses < ActiveRecord::Migration[7.0]
  def change
    remove_column :courses, :course_type_id, :integer
  end
end
