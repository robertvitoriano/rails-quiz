class ChangeIdCourseBattleMessagesTextColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :course_battle_messages, :text, :message
  end
end
