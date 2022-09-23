module Api
  module V1
  class UsersController < ApplicationController
      def create 
        begin
          user = User.create(create_user_params)
          user.save!
          render json: {status:'SUCCESS', message:'created user', data:user}, status: :ok
        rescue  Exception => ex
          render json: {status:'Not saved', message:ex}, status: :bad_request
        end 
      end

      def login
        user = User.find_by(username: login_user_params['username'])
        isAuthed = user.try(:authenticate, login_user_params['password'])

        if !user
            render json: {
                key: 'username',
                message: 'Wrong Credentials'
            }, status: :forbidden
        elsif !isAuthed
            render json: {
                key: 'password',
                message: 'Wrong Credentials'
                }, status: :forbidden
        else
          token = encode_token(user.id)
            render json: {
                id: user.id,
                username: user.username,
                token: token
            }
        end
      end

      def create_user_params
        params.permit(:name, :username, :email, :password)
      end
      def login_user_params
        params.permit(:username,:password)
      end
  end
  end
end