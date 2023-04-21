class AddDefaultValueToUserFriendStatus < ActiveRecord::Migration[7.0]
  def change
    change_column_default :user_friends, :status, "pending"
  end
end

