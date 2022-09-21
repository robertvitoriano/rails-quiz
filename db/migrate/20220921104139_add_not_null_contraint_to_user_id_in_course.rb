class AddNotNullContraintToUserIdInCourse < ActiveRecord::Migration[7.0]
  def change
    change_column_null :courses, :user_id, false
  end
end
