class RenameCourseUsersForeignKey < ActiveRecord::Migration[7.0]
  def change
    rename_column :courses, :users_id, :user_id
  end
end
