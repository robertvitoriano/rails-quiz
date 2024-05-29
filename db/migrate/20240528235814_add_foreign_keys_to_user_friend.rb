class AddForeignKeysToUserFriend < ActiveRecord::Migration[7.1]
  def change
    change_column :user_friends, :user_id1, :bigint
    change_column :user_friends, :user_id2, :bigint
    add_foreign_key :user_friends, :users, column: :user_id1
    add_foreign_key :user_friends, :users, column: :user_id2
  end
end
