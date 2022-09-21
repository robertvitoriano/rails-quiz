module Api
  module V1

    def create 
      
      user = User.create()
    end

    def create_user_params
      params.permit(:name, :username, :email, :password)
    end
    
  end
end