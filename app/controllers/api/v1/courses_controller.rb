module Api
  module V1
    class CoursesController < ApplicationController
      def index
        courses = Course.order('created_at DESC')
        render json: {status:'SUCCESS', message:'Loaded courses', data:courses}, status: :ok
      end

      def show
        courses = Course.find(params[:id])
        render json: {status:'SUCCESS', message:'found the movie', data:courses}, status: :ok
      end

      def destroy
        Course.delete(params[:id])
        render json: {status:'SUCCESS', message:'found and deleted the course'}, status: :ok
      end

      def  update
        Course.delete(params[:id])
        render json: {status:'SUCCESS', message:'found and deleted the course'}, status: :ok
      end

      def create
        begin  # "try" block7
          course = Course.create(course_params)
          course.save!
          render json: {status:'Saved Course', message:'saved the course', data: course}, status: :ok
          rescue  Exception => ex
          render json: {status:'Not saved', message:ex}, status: :bad_request
          end 
        end

      def course_params
        params.permit(:title, :goal, :course_types_id)
      end
    end
  end
end