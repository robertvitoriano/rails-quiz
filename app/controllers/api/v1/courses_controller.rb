module Api
  module V1
    class CoursesController < ApplicationController
      def index
        courses = Course.where('user_id = '+current_user_id.to_s).order('created_at DESC')
        render json: {status:'SUCCESS', message:'Loaded courses', data:courses}, status: :ok
      end

      def show
        course = Course.select("id, title, goal, cover, course_type_id as courseTypeId").where("id = "+ params[:id]).first()
        questions = CourseQuestion.select("id, question_text, course_id as courseId").where("course_id = "+ params[:id])
        questions_result = []
        question_ids = questions.map { |question| question.id }
        course_alternatives = QuestionAlternative.select("alternative_text as text, course_question_id as questionId, is_right as isRight, id").where(course_question_id: question_ids)

        questions.each_with_index do |question, index|
          question_alternatives = course_alternatives.select {|alternative| alternative.questionId == question.id}
          questions_result.push({
            :id => question[:id],
            :title => question[:question_text],
            :courseId => params[:id],
            :alternatives => question_alternatives
          })
        end

        render json: {status:'SUCCESS',
        message:'found the course',
        data:{
          :course => course,
          :questions => questions_result
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
          course_parsed = JSON.parse(course_params[:course])
          # TODO
          # DEAL WITH THE COVER IMAGE

          # s3 = Aws::S3::Client.new
          # resp = s3.list_buckets
          # puts(resp.to_s)

          # obj = s3.objects[params[:cover].original_filename]

          # # Upload the file
          # obj.write(
          #   file: params[:cover],
          #   acl: :public_read
          # )

          # # Create an object for the upload
          # @upload = Upload.new(
          #     url: obj.public_url,
          #     name: obj.key
          #   )

          # # Save the upload
          # @upload.save

          # s3 = Aws::S3::Client.new
          # resp = s3.list_buckets

          # WORKING CODE

          @tmp_path = "#{Rails.root}/tmp/storage/course_covers"

          write_file_to_storage(course_params[:cover], @tmp_path)

          object_key = course_params[:cover].original_filename
          s3_client = Aws::S3::Client.new(region: ENV["AWS_REGION"])
          encoded_image = Base64.encode64(File.open("#{Rails.root}/tmp/storage/course_covers/"+course_params[:cover].original_filename, "rb").read)

         upload_to_s3(s3_client, object_key, encoded_image)

          course = Course.create({
             :title => course_parsed['title'],
             :goal => course_parsed['goal'],
             :course_type_id => course_parsed['courseTypeId'],
             :user_id => current_user_id,
             :cover => "https://#{ENV["S3_BUCKET"]}.s3.amazonaws.com/#{object_key}"
            }
          )
          course.save!
          questions = []
          course_parsed['questions'].each_with_index do |question, index|
            course_question = CourseQuestion.create(
              {
              :question_text => question['text'],
              :course_id => course['id']
              }
            )
            course_question.save!

            alternatives = []
            for alternative in course_parsed['questions'][index]['alternatives'] do
              alternatives.push(QuestionAlternative.create(
                {
                 :course_question_id =>course_question[:id],
                 :alternative_text => alternative['text'],
                 :is_right => alternative['isRight']
                }
               )
              )
            end

            questions.push({
               :question_text => course_question[:question_text],
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
        params.permit(:course, :cover)
      end
    end
  end
end
