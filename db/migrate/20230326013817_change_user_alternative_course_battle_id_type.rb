class ChangeUserAlternativeCourseBattleIdType < ActiveRecord::Migration[7.0]
  def change
    change_column :user_alternatives, :course_battle_id, :binary, limit: 36, null: false
  end
end
