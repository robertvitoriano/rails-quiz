class CreateNotification < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.bigint :notification_type_id 
      t.boolean :read
      t.bigint :notifier_id 
      t.bigint :notified_id 
      t.timestamps
    end
    add_foreign_key :notifications, :notification_types, column: :notification_type_id
  end
end
