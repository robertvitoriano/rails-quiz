class RemoveColumnNameFromCourseBattle < ActiveRecord::Migration[7.1]
  def change
    remove_column :course_battles, :name, :string
  end
end
