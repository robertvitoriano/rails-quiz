class CreateCourseBatleUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :course_batle_users do |t|
      t.integer :user_id
      t.string :result
      t.decimal :performance
      t.integer :time_spent

      t.timestamps
    end
  end
end
