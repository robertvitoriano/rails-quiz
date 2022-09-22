class RenameUserAlternativeForeignKeys < ActiveRecord::Migration[7.0]
  def change
    rename_column :user_alternatives, :question_alternatives_id, :question_alternative_id
    rename_column :user_alternatives, :users_id, :user_id
  end
end
