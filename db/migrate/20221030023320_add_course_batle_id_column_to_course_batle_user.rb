class AddCourseBatleIdColumnToCourseBatleUser < ActiveRecord::Migration[7.0]
  def change
    add_column :course_batle_users, :course_battle_id, :integer
  end
end
