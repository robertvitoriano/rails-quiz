class AddCascadeDeleteToUserAlternatives < ActiveRecord::Migration[7.1]
  def change
        remove_foreign_key :user_alternatives, :question_alternatives, column: :question_alternative_id
        add_foreign_key :user_alternatives, :question_alternatives, column: :question_alternative_id, on_delete: :cascade
  end
end
