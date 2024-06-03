class AddDeleteCascadeToCourseBattleMessages < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :course_battle_messages, :course_battles
    add_foreign_key :course_battle_messages, :course_battles, on_delete: :cascade
  end
end
