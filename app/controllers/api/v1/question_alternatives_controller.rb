module Api
  module V1
    class QuestionAlternativesController < ApplicationController
      before_action :authenticate_user_request, only: [:save_user_answer]

      def save_user_answer
        begin
          user_answer = UserAlternative.create({
            :user_id => current_user_id,
            :question_alternative_id => save_user_answer_params['questionAlternativeId']
          })
          user_answer.save!
          render json: {status:'SUCCESS', message:'saved user answer', data: user_answer}, status: :ok
        rescue  Exception => ex
          render json: {status:'Not saved', message:ex}, status: :ok
        end
      end

     def save_user_answer_params
      params.permit(:questionAlternativeId)
     end

    end
  end
end
