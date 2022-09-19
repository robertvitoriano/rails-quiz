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
        course = Course.create(course_params)
        if course.save
          render json: {status:'Saved Course', message:'saved the course'}, status: :ok
        else
          render json: {status:'Not saved', message:'couldn"t save course'}, status: :ok
        end
      end

      def course_params
        params.permit(:title, :goal, :course_type_id)
      end
    end
  end
end