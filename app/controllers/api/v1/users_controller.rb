module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_admin_request, only: [:create_admin, :index, :destroy,]
      before_action :authenticate_user_request, only: [:check_user, :get_user_friends, :add_friend, :set_friendship_result, :unfriend ]

      def check_user
        render json: {
          status:'SUCCESS',
          message:'User exists'
        }, status: :ok
      end
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
          encoded_uri = nil
          user_parsed = JSON.parse(create_user_params[:userInfo])

          if  create_user_params[:avatar] != "null" and create_user_params[:avatar] != nil
            object_key = create_user_params[:avatar].original_filename
            s3_client = Aws::S3::Client.new(region: ENV["AWS_REGION"])
            upload_to_s3(s3_client, object_key, create_user_params[:avatar])
            uri_encoder = URI::Parser.new
            encoded_uri = uri_encoder.escape("https://#{ENV["S3_BUCKET"]}.s3.amazonaws.com/#{object_key}")
          end

          user = User.create({
            name:user_parsed["name"],
            username:user_parsed["username"],
            email:user_parsed["email"],
            password:user_parsed["password"],
            avatar:encoded_uri,
            level:"user"
            })
          user.save!
          render json: {
            status:'SUCCESS',
            message:'created user',
            data:{
              name: user[:name],
              email: user[:email],
              username: user[:username],
              avatar: encoded_uri
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
          render json: command.result
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
      def get_user_friends
        begin
          friends = UserFriend.select("*")
          .joins("JOIN users ON users.id = user_friends.user_id1 OR users.id = user_friends.user_id2")
          .where("(user_friends.user_id1 = ? OR user_friends.user_id2 = ?) AND user_friends.status = ?", current_user_id, current_user_id, "accepted")

          render json: {status:'SUCCESS', data: friends}, status: :ok

        rescue  Exception => ex
          render json: {status:'error', message:ex}, status: :bad_request
        end
      end
      def add_friend
        begin
          user_friend_already_exist = UserFriend.where("
            ((user_friends.user_id1 = ? OR user_friends.user_id2 = ?) OR user_friends.user_id2 = ? OR user_friends.user_id1 = ?)
            AND user_friends.status <> ?",
          current_user_id,add_friend_params['userId2'],current_user_id,add_friend_params['userId2'], "rejected")

          if user_friend_already_exist.present?
            render json: {status:'friendship already created', message:ex}, status: :bad_request
            else
              user_friend = UserFriend.create({
                user_id1:current_user_id,
                user_id2:add_friend_params['userId2']
              })
              user_friend.save!
              render json: {status:'SUCCESS', data: user_friend}, status: :ok
          end

        rescue Exception =>ex
          render json: {status:'error', message:ex}, status: :bad_request

        end
      end

      def set_friendship_result
        query = UserFriend.where(user_id1: friendship_result_params['userId1'], user_id2: current_user_id)
        puts query.to_sql
        query.update(status: friendship_result_params['result'])
      end

      def unfriend

      end
      def index_params
        params.permit(:limit, :page, :order)
      end
      def create_user_params
        params.permit(:userInfo, :avatar)
      end
      def create_admin_params
        params.permit(:name, :username, :email, :password, :level)
      end
      def login_user_params
        params.permit(:username,:password)
      end
      def add_friend_params
        params.permit(:userId2)
      end
      def friendship_result_params
        params.permit(:userId1, :result)
      end
  end
  end
end
