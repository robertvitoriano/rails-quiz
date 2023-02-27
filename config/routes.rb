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
          get 'check-user', to: 'users#check_user'
        end
      end
      resources :alternatives do
        collection do
          post 'save-user-answer', to: 'question_alternatives#save_user_answer'
        end
      end
      resources :course_battles do
        collection do
          get 'get-course-battle-users/:courseBattleId', to: 'course_battles#get_course_battle_users'
          post 'register-user', to: 'course_battles#register_user'
          post 'send-course-battle-message', to: 'course_battles#send_message'
          get 'get-course-battle-messages/:courseBattleId', to: 'course_battles#get_messages'
        end
      end

    end
  end
  mount ActionCable.server => '/cable'
end
