class AddCourseBatleIdToUserAlternative < ActiveRecord::Migration[7.0]
  def change
    add_column :user_alternatives, :course_battle_id, :integer
  end
end
