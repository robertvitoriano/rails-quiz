class AddForeignKeysForeignKeysToNotifierAndNotifiedInNotifications < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :notifications, :users, column: :notifier_id
    add_foreign_key :notifications, :users, column: :notified_id

  end
end
