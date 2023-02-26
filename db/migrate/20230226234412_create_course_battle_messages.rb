class CreateCourseBattleMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :course_battle_messages do |t|
      t.integer :user_id
      t.string :text
      t.string :string
      t.binary :course_battle_id, limit: 36

      t.timestamps
    end
  end
end
