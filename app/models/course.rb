class Course < ApplicationRecord
  belongs_to :course_type, optional:true
  belongs_to :user, optional:true
  has_many :course_question
  has_many :course_battles

end
