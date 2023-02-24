class CourseBattle < ApplicationRecord
  before_create :set_uuid
  private

  def set_uuid
    self.id = SecureRandom.uuid
  end

  self.primary_key = :id
end
