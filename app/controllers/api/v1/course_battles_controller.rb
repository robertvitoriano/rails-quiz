module Api
  module V1
   class CourseBattlesController < ApplicationController
    before_action :authenticate_user_request, only: [:create]
    before_action :authenticate_user_request, only: [:index]
      def create
        begin
         course_battle_created = CourseBattle.create({
          :name => course_battle_params[:name],
          :course_id => course_battle_params[:course_id]
        })
         course_battle_created.save!
         render json: {
          status: 200,
          message:'saved the course battle',
          data:{:courseBattle => course_battle_created,
          }
        },
        status: :ok

        puts "WHAT A FUCK"
        rescue  Exception => ex
          render json: {status:'Not saved', message:ex}, status: :bad_request
        end
      end

      def course_battle_params
        params.permit(:name, :course_id)
      end
    end
  end
end
