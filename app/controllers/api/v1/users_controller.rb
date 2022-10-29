module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_user_request

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
        command = AuthenticateUser.call(login_user_params[:username], login_user_params[:password])

        if command.success?
          render json: { token: command.result }
        else
          render json: { error: command.errors }, status: :unauthorized
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
