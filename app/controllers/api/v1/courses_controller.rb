module Api
  module V1
    class CoursesController < ApplicationController
      def index
        courses = Course.order('created_at DESC')
        render json: {status:'SUCCESS', message:'Loaded courses', data:params}, status: :ok
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
        begin  
          course = Course.create({
             :title => course_params[:title],
             :goal => course_params[:goal],
             :course_type_id => course_params[:course_type_id]
            })
          course.save!
          questions = []
          for q in course_params[:questions] do
            course_question = CourseQuestion.create(
              {
              :question_text => q[:question_text],
              :course_id => course[:id]
              }
            )
            course_question.save!
            questions.push(course_question)
          end

          render json: {
                        status:'Saved Course',
                        message:'saved the course',
                        data:{:course => course,
                              :questions => questions
                         }
                      },
                     status: :ok
          rescue  Exception => ex
          render json: {status:'Not saved', message:ex}, status: :bad_request
          end 
        end

      def course_params
        params.permit(
           :title,
           :goal,
           :course_type_id,
           questions:[:question_text, question_alternatives:[:is_right, :alternative_text]]
            )

      end
    end
  end
end