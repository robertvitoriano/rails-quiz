module Api 
  module V1 
   class CourseTypesController < ApplicationController 
      def index
        course_types = CourseType.order('created_at DESC')
        render json: {status:'SUCCESS', message:'Loaded course types', data:course_types}, status: :ok
      end
    end
  end
end