class DropUniqueIndexFromUserAlternative < ActiveRecord::Migration[7.1]
  def change
    remove_index :user_alternatives, name: :unique_user_alternattive_index_by_batle
  end
end
