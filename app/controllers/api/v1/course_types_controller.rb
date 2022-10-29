module Api
  module V1
   class CourseTypesController < ApplicationController
    before_action :authenticate_admin_request, only: [:create]
    before_action :authenticate_user_request, only: [:index]

      def index
        course_types = CourseType.order('created_at DESC')
        render json: {status:'SUCCESS', message:'Loaded courses', data:course_types}, status: :ok
      end

      def create
        course_types = CourseType.create(course_types_params)
        if course_types.save
          render json: {status:'Saved Course Type', message:'saved the course type', data: course_types}, status: :ok
        else
          render json: {status:'Not saved', message:'couldn"t save course type'}, status: :ok
        end
      end

      def course_types_params
        params.permit(:title)
      end
    end
  end
end
