class RenameReadColumnInNotifications < ActiveRecord::Migration[7.0]
  def change
    rename_column :notifications, :read, :is_read
  end
end
