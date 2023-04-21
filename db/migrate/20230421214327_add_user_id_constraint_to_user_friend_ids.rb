class AddUserIdConstraintToUserFriendIds < ActiveRecord::Migration[7.0]
  def change
    add_index :user_friends, [:user_id1, :user_id2], unique: true
  end
end
