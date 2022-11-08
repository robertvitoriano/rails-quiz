Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :course_types, :course_questions
      resources :courses do
        collection do
          get 'get-battle-courses', to:'courses#get_battle_courses'
        end
      end
      resources :users do
        collection do
          post :login
          post 'create-user', to: 'users#create_user'
          post 'create-admin', to: 'users#create_admin'
        end
      end
      resources :alternatives do
        collection do
          post 'save-user-answer', to: 'question_alternatives#save_user_answer'
        end
      end
    end
  end
end
