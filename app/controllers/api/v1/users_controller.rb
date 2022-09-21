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
        user = User.find_by(username: params['username'])
        isAuthed = user.try(:authenticate, params['password'])

        if !user
            render json: {
                key: 'username',
                message: 'No user can be found with that Username'
            }, status: :forbidden
        elsif !isAuthed
            render json: {
                key: 'password',
                message: 'Incorrect Password'
                }, status: :forbidden
        else
            render json: {
                id: user.id,
                username: user.username,
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