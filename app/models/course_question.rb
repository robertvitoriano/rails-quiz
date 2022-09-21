class CourseQuestion < ApplicationRecord
  belongs_to :course
  has_many :question_alternative
end
