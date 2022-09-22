class CreateUserAlternatives < ActiveRecord::Migration[7.0]
  def change
    create_table :user_alternatives do |t|

      t.timestamps
    end
  end
end
