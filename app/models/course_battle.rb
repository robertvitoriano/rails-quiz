class CourseBattle < ApplicationRecord
  has_many :course_battle_users
  belongs_to :course
  before_create :set_uuid
  private

  def set_uuid
    self.id = SecureRandom.uuid
  end

  self.primary_key = :id
end
