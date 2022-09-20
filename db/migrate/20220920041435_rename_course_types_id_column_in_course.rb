class RenameCourseTypesIdColumnInCourse < ActiveRecord::Migration[7.0]
  def change
    rename_column :courses, :course_types_id, :course_type_id
  end
end
