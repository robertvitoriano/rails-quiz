class RemoveStringColumnFromCourseBattleMessage < ActiveRecord::Migration[7.0]
  def change
    remove_column :course_battle_messages, :string
  end
end
