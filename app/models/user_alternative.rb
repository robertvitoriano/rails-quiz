class UserAlternative < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  has_many :user_alternative, foreign_key: "user_id"
end
