class ChangeUserFriendStatusToEnum < ActiveRecord::Migration[7.0]
  def change
    change_column :user_friends, :status, "enum('accepted','rejected','pending')", null: false
  end
end
