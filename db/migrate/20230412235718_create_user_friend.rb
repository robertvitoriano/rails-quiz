class CreateUserFriend < ActiveRecord::Migration[7.0]
  def change
    create_table :user_friends do |t|
      t.integer :user_id1
      t.integer :user_id2
      t.string :status
      t.timestamps
    end
  end
end
