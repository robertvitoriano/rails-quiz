module Api
  module V1
    class QuestionAlternativesController < ApplicationController
      def save_user_answer
        begin
          user_answer = UserAlternative.create({
            :user_id => current_user_id,
            :question_alternative_id => params['question_alternative_id']
          })
          user_answer.save!
          render json: {status:'SUCCESS', message:'saved user answer', data: user_answer}, status: :ok
        rescue  Exception => ex 
          render json: {status:'Not saved', message:ex}, status: :ok
        end
      end
    end
  end
end