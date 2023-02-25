module Api
  module V1
   class CourseBattlesController < ApplicationController
    before_action :authenticate_user_request, only: [:create]
    before_action :authenticate_user_request, only: [:index]
      def create
        begin
         course_battle_created = CourseBattle.create({
          :name => course_battle_creation_params[:name],
          :course_id => course_battle_creation_params[:courseId]
        })
        course_battle_user = CourseBattleUser.create({
          course_battle_id: course_battle_created[:id],
          user_id: course_battle_creation_params[:userId]
        })

         course_battle_created.save!
         render json: {
          status: 200,
          message:'saved the course battle',
          data:{:courseBattle => course_battle_created,
          }
        },
        status: :ok

        rescue  Exception => ex
          render json: {status:'Not saved', message:ex}, status: :bad_request
        end
      end

      def get_course_battle_users
        begin
          course_battle_users = CourseBattleUser.select("course_battle_users.id, user_id, users.name")
                                                .joins(:course_battle)
                                                .joins(:user)
                                                .where({course_battle_id:params['courseBattleId']})
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

      def course_battle_creation_params
        params.permit(:name, :courseId, :userId)
      end
    end
  end
end
