class UserAlternative < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  has_many :user_alternative, foreign_key: "user_id"
  validates :user_id, uniqueness: { scope: :question_alternative_id }
end
