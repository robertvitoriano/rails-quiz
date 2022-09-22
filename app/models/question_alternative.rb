class QuestionAlternative < ApplicationRecord
  belongs_to :course_question
  has_many :user_alternative
end
