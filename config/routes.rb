Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :courses, :course_types, :course_questions, :question_alternatives, :users
    end
  end
end