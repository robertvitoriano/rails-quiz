module Api
  module V1
    class QuestionAlternativesController < ApplicationController
      before_action :authenticate_user_request, only: [:save_user_answer]

      def save_user_answer
        @user_answer = UserAlternative.new({
          user_id: current_user[:id],
          question_id: params['questionId'],
          question_alternative_id: params['questionAlternativeId'],
          course_battle_id: params['courseBattleId']
        })
      
        
        @user_answer.save!
        
          render json: {status:'SUCCESS', message:'saved user answer', data: @user_answer}, status: :ok
        rescue  Exception => ex
          render json: {status:'Not saved', message:ex}, status: :bad_request
        end
      end

      def get_user_answers
      end

     def save_user_answer_params
      params.permit(:questionAlternativeId, :courseBattleId, :questionId)
     end

    end
  end

