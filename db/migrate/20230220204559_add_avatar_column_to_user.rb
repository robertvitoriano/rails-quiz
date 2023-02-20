class AddAvatarColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :avatar, :string, :default => nil
  end
end
