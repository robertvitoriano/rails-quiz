class User < ApplicationRecord
  has_many :course_battle_users
  has_many :courses
  has_many :course_battle_messages
  validates :username, presence: true, uniqueness: true
  has_secure_password
end
