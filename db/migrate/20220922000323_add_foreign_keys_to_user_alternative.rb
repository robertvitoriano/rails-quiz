class AddForeignKeysToUserAlternative < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_alternatives, :users, references: :users, foreign_key: true
    add_reference :user_alternatives, :question_alternatives, references: :question_alternatives, foreign_key: true
  end
end
