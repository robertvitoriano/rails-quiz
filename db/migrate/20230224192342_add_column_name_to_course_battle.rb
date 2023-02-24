class AddColumnNameToCourseBattle < ActiveRecord::Migration[7.0]
  def change
    add_column :course_battles, :name, :string
  end
end
