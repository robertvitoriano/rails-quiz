class RemoveQuestionIdFromUserAlternatives < ActiveRecord::Migration[7.1]
  def change
    remove_column :user_alternatives, :question_id, :binary
  end
end
