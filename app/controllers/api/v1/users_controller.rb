module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_admin_request, only: [:create_admin, :index, :destroy]

      def index
        page = index_params[:page] != nil ? index_params[:page].to_i : 1
        limit = index_params[:limit] != nil ? index_params[:limit].to_i : 60
        offset = page != nil ? (page - 1 ) * limit : 0
        order = index_params[:order] != nil ? index_params[:order] : 'DESC'
        begin
          users = User.select("id, name, username, email, level, created_at as createdAt, updated_at as updatedAt")
            .limit(limit)
            .offset(offset)
            .order('createdAt '+ order)

          total = User.count('id')

          render json: {
            status:'SUCCESS',
            message:'Loaded users',
            data:{
              users:users,
              total:total
            }
          }, status: :ok

        rescue Exception => ex
          render json: {status:'error', message:ex}, status: :bad_request
        end
      end
      def create_user
        begin
          user = User.create({
            name:create_user_params[:name],
            username:create_user_params[:username],
            email:create_user_params[:email],
            password:create_user_params[:password],
            level:"user"
            })
          user.save!
          render json: {
            status:'SUCCESS',
            message:'created user',
            data:{
              name: user[:name],
              email: user[:email],
              username: user[:username]
          }}, status: :ok
        rescue  Exception => ex
          render json: {status:'Not saved', message:ex}, status: :bad_request
        end
      end

      def create_admin
        begin
          user = User.create(create_admin_params)
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
      def destroy
        begin
					User.delete(params[:id])
          render json: {status:'SUCCESS', message:'deleted the user'}, status: :ok
        rescue  Exception => ex
          render json: {status:'error', message:ex}, status: :bad_request
        end
      end
      def index_params
        params.permit(:limit, :page, :order)
      end
      def create_user_params
        params.permit(:name, :username, :email, :password)
      end
      def create_admin_params
        params.permit(:name, :username, :email, :password, :level)
      end
      def login_user_params
        params.permit(:username,:password)
      end
  end
  end
end
