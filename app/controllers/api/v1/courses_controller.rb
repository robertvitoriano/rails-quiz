module Api
  module V1
    class CoursesController < ApplicationController
      def index
        courses = Course.order('created_at DESC')
        render json: {status:'SUCCESS', message:'Loaded courses', data:courses}, status: :ok
      end

      def show
        course = Course.find(params[:id])
        questions = CourseQuestion.where("course_id = "+ params[:id])

        render json: {status:'SUCCESS',
        message:'found the movie',
        data:{
          :course => course,
          :questions => questions
        }},
        status: :ok
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
             :course_type_id => course_params[:courseTypeId],
             :user_id => current_user_id,
             :cover => course_params[:cover] != nil ? course_params[:cover] : 'https://d3njjcbhbojbot.cloudfront.net/api/utilities/v1/imageproxy/https://coursera-course-photos.s3.amazonaws.com/cb/3c4030d65011e682d8b14e2f0915fa/shutterstock_226881610.jpg?auto=format%2Ccompress&dpr=1'
            }
          )
          course.save!
          questions = []

          course_params[:questions].each_with_index do |question, index|
            course_question = CourseQuestion.create(
              {
              :question_text => question[:text],
              :course_id => course[:id]
              }
            )
            course_question.save!

            alternatives = []
            for alternative in course_params[:questions][index][:alternatives] do
              alternatives.push(QuestionAlternative.create(
                {
                 :course_question_id =>course_question[:id],
                 :alternative_text => alternative[:text],
                 :is_right => alternative[:isRight]
                }
               )
              )
            end

            questions.push({
               :question_text => question[:question_text],
               :course_id => course_question[:course_id],
               :alternatives => alternatives
              }
            )

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
           :courseTypeId,
           :cover,
           questions:[:text, alternatives:[:isRight, :text]]
            )
      end
    end
  end
end
