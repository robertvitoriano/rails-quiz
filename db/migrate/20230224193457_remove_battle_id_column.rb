class RemoveBattleIdColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :course_battles, :battle_id
  end
end
