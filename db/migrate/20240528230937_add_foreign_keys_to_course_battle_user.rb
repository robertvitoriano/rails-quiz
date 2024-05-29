class AddForeignKeysToCourseBattleUser < ActiveRecord::Migration[7.1]
  def change
    unless foreign_key_exists?(:course_battle_users, column: :course_battle_id)
      add_foreign_key :course_battle_users, :course_battles, column: :course_battle_id
    end
  end

  private

  def foreign_key_exists?(table, column:)
    foreign_keys = ActiveRecord::Base.connection.foreign_keys(table)
    foreign_keys.any? { |fk| fk.column == column.to_s }
  end
end
