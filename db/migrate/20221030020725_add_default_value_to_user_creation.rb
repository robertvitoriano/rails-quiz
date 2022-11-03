class AddDefaultValueToUserCreation < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :created_at,Time.zone.now
    change_column_default :users, :updated_at, Time.zone.now

  end
end
