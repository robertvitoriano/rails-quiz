class AddAwaitingOpponentResultToCourseBattleUsers < ActiveRecord::Migration[7.1]
  def up
    CourseBattleUser.where(result: nil).update_all(result: 'not-finished')

    change_column :course_battle_users, :result, "enum('won','lost','awaiting-opponent','not-finished')", null: false, default: 'not-finished'
  end

  def down
    # Revert changes (if necessary)
    change_column :course_battle_users, :result, "enum('won','lost','awaiting-opponent','not-finished')", null: true, default: nil
  end
end
