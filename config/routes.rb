Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :courses, :course_types
    end
  end
end