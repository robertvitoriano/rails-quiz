class CreateBatles < ActiveRecord::Migration[7.0]
  def change
    create_table :batles do |t|
      t.string :title
      t.integer :duration

      t.timestamps
    end
  end
end
