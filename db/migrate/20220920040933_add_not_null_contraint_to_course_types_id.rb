class AddNotNullContraintToCourseTypesId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :courses, :course_types_id, false
  end
end
