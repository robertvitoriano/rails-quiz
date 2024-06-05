class AddIndexToUserAlternative < ActiveRecord::Migration[7.1]
  def change
    add_index :user_alternatives,["user_id", "question_alternative_id", "course_battle_id"], unique: true, name: 'unique_user_alternattive_index_by_battle'
  end
end
