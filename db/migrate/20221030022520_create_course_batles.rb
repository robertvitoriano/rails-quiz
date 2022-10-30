class CreateCourseBatles < ActiveRecord::Migration[7.0]
  def change
    create_table :course_batles do |t|
      t.integer :course_id
      t.integer :battle_id

      t.timestamps
    end
  end
end
