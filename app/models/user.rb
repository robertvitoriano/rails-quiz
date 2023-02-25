class User < ApplicationRecord
  belongs_to :course_batle_users
  has_many :courses
  validates :username, presence: true, uniqueness: true
  has_secure_password
end
