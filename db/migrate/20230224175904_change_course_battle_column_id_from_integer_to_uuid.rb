class ChangeCourseBattleColumnIdFromIntegerToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :course_battles, :id, :binary, limit: 16, null: false
  end
end
