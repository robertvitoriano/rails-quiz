class CourseType < ApplicationRecord
  has_many :course, foreign_key: 'course_types_id'
end
