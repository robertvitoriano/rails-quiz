Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :course_types, :course_questions
      resources :courses do
        collection do
          get 'get-battle-courses', to:'courses#get_battle_courses'
          get 'course-battles/:courseBattleId', to: 'courses#get_course_battle'
        end
      end
      resources :notifications do
        collection do
          get '/notifications', to:'notifications#get_notifications'
        end
      end
      resources :users do
        collection do
          post :login
          post 'oauth-login', to: 'users#oauth_login'
          post 'create-user', to: 'users#create_user'
          post 'create-admin', to: 'users#create_admin'
          get 'check-user', to: 'users#check_user'
          post 'friends/add-friend', to: 'users#add_friend'
          put 'friends/friendship-result', to:'users#set_friendship_result'
          get 'friends/non-friends', to: 'users#list_non_friends'
          get 'friends/:userId', to: 'users#get_user_friends'
        end
      end
      resources :alternatives do
        collection do
          post 'save-user-answer', to: 'question_alternatives#save_user_answer'
        end
      end
      resources :course_battles do
        collection do
          get 'result/:courseBattleId', to: 'course_battles#get_course_battle_result'
          get 'get-course-battle-users/:courseBattleId', to: 'course_battles#get_course_battle_users'
          post 'register-user', to: 'course_battles#register_user'
          post 'send-course-battle-message', to: 'course_battles#send_message'
          get 'get-course-battle-messages/:course_battle_id', to: 'course_battles#get_messages'
          post 'finish-course-battle', to: 'course_battles#finish_course_battle'
          
        end
      end

    end
  end
  mount ActionCable.server => '/cable'
end
