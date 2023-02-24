module Api
  module V1
    class CourseBattleController < ApplicationController
      def create
        begin
         CourseBattle.create()
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
