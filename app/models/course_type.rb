class CourseType < ApplicationRecord
  has_many :courses, foreign_key: 'course_id'
end
