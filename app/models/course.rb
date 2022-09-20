class Course < ApplicationRecord
  belongs_to :course_type, optional:true
  has_many :course_questions
end
