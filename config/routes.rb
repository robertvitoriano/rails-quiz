Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :courses, :course_types, :course_questions
      resources :users do
        collection do
          post :login
        end
      end
      resources :question_alternatives do
        collection do
          post 'save-user-answer', to: 'question_alternatives#save_user_answer'
        end
      end
    end
  end
end