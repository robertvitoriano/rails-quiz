class DropUserAlternativeIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :user_alternatives, name: 'index_user_alternatives_on_user_id_and_question_alternative_id'
  end
end
