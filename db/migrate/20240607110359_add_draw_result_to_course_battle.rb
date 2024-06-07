class AddDrawResultToCourseBattle < ActiveRecord::Migration[7.1]
  def change
    change_column :course_battle_users, :result, "enum('won','lost','awaiting-opponent','not-finished','draw')", null: false, default: 'not-finished'
  end
end
