module Api
  module V1
   class CourseBattlesController < ApplicationController
    before_action :authenticate_user_request, only: [:create]
    before_action :authenticate_user_request, only: [:index]
    def create
      begin
        course_battle_created = CourseBattle.create({
          name: course_battle_creation_params[:name],
          course_id: course_battle_creation_params[:courseId]
        })
        course_battle_user = CourseBattleUser.create({
          course_battle_id: course_battle_created[:id],
          user_id: course_battle_creation_params[:userId]
        })

        render json: {
          status: 200,
          message: 'saved the course battle',
          data: { courseBattle: course_battle_created }
        }, status: :ok

      rescue ActiveRecord::RecordInvalid => ex
        render json: {
          status: 'Not saved',
          message: ex.message
        }, status: :bad_request
      end
    end


      def get_course_battle_users
        begin
          course_battle_users = CourseBattleUser.select("course_battle_users.id, user_id as userId, users.name, users.avatar")
                                                .joins(:course_battle)
                                                .joins(:user)
                                                .where({course_battle_id:params['courseBattleId']})
                                                .order('course_battle_users.created_at ASC ')
          render json: {
            status: 200,
            message:'course battle users found',
            data:{ :courseBattleUsers => course_battle_users }
          },
          status: :ok

        rescue Exception => ex
          render json: {status:'Not saved', message:ex}, status: :bad_request
        end
      end

      def register_user
        begin
          is_user_registered = CourseBattleUser.exists?(user_id: params["userId"], id:params['courseBattleId'])
          if is_user_registered
            render json: {
              status: 200,
              message: 'user already registered'
            }, status: :ok
          else
            CourseBattleUser.create({
              course_battle_id: params["courseBattleId"],
              user_id: params["userId"]
            })
            user = User.find_by(id: params["userId"])
            ActionCable.server.broadcast("course_battle_chat_#{params["courseBattleId"]}",{userId:user.id, name:user.name, avatar:user.avatar,courseBattleId:params["courseBattleId"], type:"user_registered"})

            render json: {
              status: 200,
              message: 'user was registered'
            }, status: :ok
          end
        rescue Exception => ex
          render json: {
            status: 'user could not be registered',
            message: ex.to_s
          }, status: :bad_request
        end
      end

      def send_message
        begin
          ActionCable.server.broadcast "course_battle_chat_#{params[:courseBattleId]}", { message: params['message'], userId: params['userId'],type: "battle_room_message"}
          CourseBattleMessage.create({
            user_id:params[:userId],
            message:params[:message],
            course_battle_id: params[:courseBattleId]
          })
          render json: {
            status: 200,
            message: 'messages saved',
          }, status: :ok
        rescue Exception => ex
         render json: {status:'could not send message', message:ex}, status: :bad_request
        end
      end

      def get_messages
        begin
        messages = CourseBattleMessage
        .select("id,
          user_id as userId,
          course_battle_id as courseBattleId,
          message,
          created_at as createdAt")
          .where({course_battle_id:params[:course_battle_id]})
          
        render json: {
          status: 200,
          message: 'messages found',
          data: {:messages => messages}
        }, status: :ok

        rescue Exception => ex
        render json: {
          status: 'could not get messages',
          message: ex.to_s
        }, status: :bad_request
        end
      end

      def course_battle_creation_params
        params.permit(:name, :courseId, :userId)
      end
    end
  end
end
