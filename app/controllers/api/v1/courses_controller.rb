require 'uri'

module Api
	module V1
		class CoursesController < ApplicationController
			before_action :authenticate_admin_request, only: [:create, :update, :destroy, :index ]
			before_action :authenticate_user_request, only: [:get_battle_courses, :show, ]

			def index
				limit = params['limit'] != nil ? params['limit'].to_i : 400
				offset = params['page'] != nil ? (params['page'].to_i - 1) * params['limit'].to_i : 0
				order = params['order'] != nil ? params['order'].to_s : 'DESC'

				courses = Course.select("
          courses.id,
          courses.title,
          COUNT(course_questions.id) as questions,
          courses.created_at as createdAt,
          courses.updated_at as updatedAt,
          users.username as createdBy,
          course_types.title as courseType
          ")
          .joins(:user)
          .joins(:course_type)
          .joins(:course_question)
          .group(:id)
          .limit(limit)
          .offset(offset)
          .order('courses.created_at '+ order)

				total = Course.count('id')

				render json: {
					status: 200,
					message:'Loaded courses',
					data:{
						courses:courses,
						total:total
					}
				}, status: :ok
			end

			def get_battle_courses
				limit = params['limit'] != nil ? params['limit'].to_i : 100
				offset = params['page'] != nil ? (params['page'].to_i - 1) * params['limit'].to_i : 0
				order = params['order'] != nil ? params['order'].to_s : 'DESC'

				courses = Course.select("
          courses.id,
          courses.title,
          courses.created_at as createdAt,
          courses.updated_at as updatedAt,
          course_types.title as courseType,
					cover
          ")
          .joins(:user)
          .joins(:course_type)
          .limit(limit)
          .offset(offset)
          .order('courses.created_at '+ order)

				render json: {
					status: 200,
					message:'Loaded courses',
					data:{
						courses:courses,
					}
				}, status: :ok
			end

			def show
				course = Course.select("id, title, goal, cover, course_type_id as courseTypeId").where("id = "+ params[:id]).first()
				questions = CourseQuestion.select("id, question_text, course_id as courseId").where("course_id = "+ params[:id])
				questions_result = []
				question_ids = questions.map { |question| question.id }
				course_alternatives = QuestionAlternative.select("alternative_text as text, course_question_id as questionId, is_right as isRight, id").where(course_question_id: question_ids)
				course_type = CourseType.select("id, title").where("id = "+course.courseTypeId.to_s)
				questions.each_with_index do |question, index|
					question_alternatives = course_alternatives.select {|alternative| alternative.questionId == question.id}
					questions_result.push({
						:id => question[:id],
						:text => question[:question_text],
						:courseId => params[:id],
						:alternatives => question_alternatives
					})
				end

				render json: {
					status:200,
					message:'found the course',
					data:{
						:course => course,
						:questions => questions_result,
						:courseType => course_type
					}},
					status: :ok
				end

				def destroy
					course_to_be_deleted =Course.find(params[:id])
					key = course_to_be_deleted[:cover].split('amazonaws.com/')[1]
					s3_client = Aws::S3::Client.new(region: ENV["AWS_REGION"])
					s3_client.delete_object({
						bucket: "rails-quiz",
						key: key.gsub("%20", " "),
					})
					Course.delete(params[:id])
					render json: {status:'SUCCESS', message:'found and deleted the course'}, status: :ok
				end

				def  update
					encoded_uri = nil
					course_parsed = JSON.parse(course_params[:course])
					deleted_question_ids = course_params[:deletedQuestionIds] != nil ? JSON.parse(course_params[:deletedQuestionIds]) : []
					deleted_alternative_ids = course_params[:deletedAlternativeIds] != nil ? JSON.parse(course_params[:deletedAlternativeIds]) : []

					for deleted_question_id in	deleted_question_ids do
						CourseQuestion.delete(deleted_question_id)
					end
					for deleted_alternative_id in	deleted_alternative_ids do
						QuestionAlternative.delete(deleted_alternative_id)
					end
					begin

						if  course_params[:cover] != "null" and course_params[:cover] != nil
							object_key = course_params[:cover].original_filename
							s3_client = Aws::S3::Client.new(region: ENV["AWS_REGION"])
							upload_to_s3(s3_client, object_key, course_params[:cover])
							uri_encoder = URI::Parser.new
							encoded_uri = uri_encoder.escape("https://#{ENV["S3_BUCKET"]}.s3.amazonaws.com/#{object_key}")
						end

						course = Course.update(
							course_parsed['id'].to_i,
							{
								:title => course_parsed['title'],
								:goal => course_parsed['goal'],
								:course_type_id => course_parsed["courseTypeId"],
								:user_id => current_user_id,
								:cover => encoded_uri == nil ? course_parsed['oldCover'] : encoded_uri,
								:updated_at => Time.zone.now
							}
						)
						course.save!

						for question in course_parsed['questions'] do
							updated_question = {}

							if question["new"]
								updated_question = CourseQuestion.create({
									:question_text => question['text'],
									:course_id => course[:id],
								})
							else
								updated_question = CourseQuestion.update(question["id"],{
									:question_text => question['text'],
								})
							end

							updated_question.save!

							for alternative in question['alternatives'] do
                updated_alternative = {}
								if alternative["new"]
									updated_alternative = QuestionAlternative.create({
										:alternative_text => alternative["text"],
										:is_right => alternative["isRight"],
                    :course_question_id => updated_question[:id]
									})
								else
									updated_alternative = QuestionAlternative.update(alternative["id"],{
										:alternative_text => alternative["text"],
										:is_right => alternative["isRight"]
									})
								end
                updated_alternative.save!
							end
						end

						render json: {
							status: 200,
							message:'saved the course',
							data:{:course => course,
							}
						},
						status: :ok
					rescue  Exception => ex
						render json: {status:'Not saved', message:ex}, status: :bad_request
					end
				end

				def create
					begin

						encoded_uri = nil
						course_parsed = JSON.parse(course_params[:course])

						if  course_params[:cover] != "null" and course_params[:cover] != nil
							object_key = course_params[:cover].original_filename
							s3_client = Aws::S3::Client.new(region: ENV["AWS_REGION"])
							upload_to_s3(s3_client, object_key, course_params[:cover])
							uri_encoder = URI::Parser.new
							encoded_uri = uri_encoder.escape("https://#{ENV["S3_BUCKET"]}.s3.amazonaws.com/#{object_key}")
						end

						course = Course.create({
							:title => course_parsed['title'],
							:goal => course_parsed['goal'],
							:course_type_id => course_parsed['courseTypeId'],
							:user_id => current_user_id,
							:cover => encoded_uri
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
				status: 200,
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
		params.permit(:course, :cover, :deletedQuestionIds, :deletedAlternativeIds)
	end
end
end
end
