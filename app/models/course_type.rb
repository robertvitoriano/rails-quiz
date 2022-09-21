class CourseType < ApplicationRecord
  has_many :course, foreign_key: 'course_type_id'
end
