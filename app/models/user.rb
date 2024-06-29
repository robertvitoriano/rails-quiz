class User < ApplicationRecord
  has_many :course_battle_users
  has_many :user_alternatives
  has_many :courses
  has_many :course_battle_messages
  validates :username, presence: true, uniqueness: true
  has_secure_password
  
  validates :password, presence: true, unless: :google_oauth?

  def google_oauth?
    self.provider == 'google_oauth2'
  end
end
