class AddUniqueIndexToUserAlternative < ActiveRecord::Migration[7.0]
  def change
    add_index :user_alternatives, [:user_id, :question_alternative_id], unique: true
  end
end