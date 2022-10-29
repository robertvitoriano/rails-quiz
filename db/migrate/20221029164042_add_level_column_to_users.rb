class AddLevelColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :level, "enum('user','admin')", :default => 'user'
  end
end
