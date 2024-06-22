module Api
  module V1
   class CourseBattlesController < ApplicationController
      before_action :authenticate_user_request, only: [
          :create, 
          :index,
          :get_course_battle_users,
          :register_user, 
          :send_message, 
          :get_messages, 
          :finish_course_battle,
          :show,
          :get_course_battle_result
        ]
      
      def index
        begin
          course_battles = CourseBattle.joins(:course_battle_users)
                                       .joins("INNER JOIN courses ON courses.id = course_battles.course_id")
                                       .select('course_battles.id, 
                                                course_battles.course_id as courseId, 
                                                courses.title as name, 
                                                course_battles.created_at as createdAt, 
                                                course_battles.updated_at as updatedAt,
                                                courses.cover')
                                       .where(course_battle_users: { user_id: current_user.id })
                                       .order('course_battles.created_at DESC')
      
          render json: {
            status: 200,
            message: 'Course battles found!',
            data: { courseBattles: course_battles }
          }, status: :ok
        rescue ActiveRecord::RecordInvalid => ex
          render json: {
            status: 'Not saved',
            message: ex.message
          }, status: :bad_request
        end
      end
      
			def show
				course_battle = CourseBattle.select('course_id').where("id = ?", params[:id]).first()
				course = Course.select("id, title, goal, cover, course_type_id as courseTypeId").where("id = ?", course_battle.course_id).first()
				questions = CourseQuestion.select("id, question_text, course_id as courseId").where("course_id = ?", course_battle.course_id)
				questions_result = []
				question_ids = questions.map { |question| question.id }
				course_alternatives = QuestionAlternative.select("alternative_text as text,
					 course_question_id as questionId, 
					 is_right as isRight,
					 id").where(course_question_id: question_ids)
           
        course_battle_alternatives = get_course_battle_alternatives(question_ids, current_user[:id], params[:id])
        
				course_type = CourseType.select("id, title").where("id = "+course.courseTypeId.to_s)
				questions.each_with_index do |question, index|
					question_alternatives = course_alternatives.select {|alternative| alternative.questionId == question.id}
					question_chosen_alternative_result = course_battle_alternatives.select {|alternative| alternative.questionId == question.id}
					question_chosen_alternative = question_chosen_alternative_result[0]

					questions_result.push({
						:id => question[:id],
						:text => question[:question_text],
						:courseId => params[:courseBattleId],
						:alternatives => question_alternatives,
						:userAlternative => question_chosen_alternative
					})
				end

				render json: {
					status:200,
					message:'found the course',
					data:{
						:course => course,
						:questions => questions_result,
						:courseType => course_type
					}
				},
					status: :ok
			end
      
      def create
        begin
          course_battle_created = CourseBattle.create({
            course_id: course_battle_creation_params[:courseId]
          })
          course_battle_user = CourseBattleUser.create({
            course_battle_id: course_battle_created[:id],
            user_id: course_battle_creation_params[:userId]
          })

          render json: {
            status: 200,
            message: 'saved the course battle',
            data: { courseBattle: course_battle_created }
          }, status: :ok

        rescue ActiveRecord::RecordInvalid => ex
          render json: {
            status: 'Not saved',
            message: ex.message
          }, status: :bad_request
        end
      end


      def get_course_battle_users
        begin
          course_battle_users = CourseBattleUser.select("course_battle_users.id, user_id as userId, users.name, users.avatar")
                                                .joins(:course_battle)
                                                .joins(:user)
                                                .where({course_battle_id:params['courseBattleId']})
                                                .order('course_battle_users.created_at ASC ')
          render json: {
            status: 200,
            message:'course battle users found',
            data:{ :courseBattleUsers => course_battle_users }
          },
          status: :ok

        rescue Exception => ex
          render json: {status:'Not saved', message:ex}, status: :bad_request
        end
      end

      def register_user
        begin
          is_user_registered = CourseBattleUser.exists?(user_id: params["userId"], id:params['courseBattleId'])
          if is_user_registered
            render json: {
              status: 200,
              message: 'user already registered'
            }, status: :ok
          else
            CourseBattleUser.create({
              course_battle_id: params[:courseBattleId],
              user_id: params["userId"]
            })
            user = User.find_by(id: params["userId"])
            ActionCable.server.broadcast("course_battle_chat_#{params[:courseBattleId]}",{userId:user.id, name:user.name, avatar:user.avatar,courseBattleId:params[:courseBattleId], type:"user_registered"})

            render json: {
              status: 200,
              message: 'user was registered'
            }, status: :ok
          end
        rescue Exception => ex
          render json: {
            status: 'user could not be registered',
            message: ex.to_s
          }, status: :bad_request
        end
      end

      def send_message
        begin
          ActionCable.server.broadcast "course_battle_chat_#{params[:courseBattleId]}", { message: params['message'], userId: params['userId'],type: "battle_room_message"}
          CourseBattleMessage.create({
            user_id:params[:userId],
            message:params[:message],
            course_battle_id: params[:courseBattleId]
          })
          render json: {
            status: 200,
            message: 'messages saved',
          }, status: :ok
        rescue Exception => ex
          render json: {status:'could not send message', message:ex}, status: :bad_request
        end
      end

      def get_messages
        begin
        messages = CourseBattleMessage
        .select("id,
          user_id as userId,
          course_battle_id as courseBattleId,
          message,
          created_at as createdAt")
          .where({course_battle_id:params[:course_battle_id]})
          
        render json: {
          status: 200,
          message: 'messages found',
          data: {:messages => messages}
        }, status: :ok

        rescue Exception => ex
        render json: {
          status: 'could not get messages',
          message: ex.to_s
        }, status: :bad_request
        end
      end
      
      def get_course_battle_result
        begin

          registered_users = CourseBattleUser.select(
            "result, performance, time_spent, user_id"
          ).where(course_battle_id: params[:courseBattleId].to_s)
          
          current_user_register = registered_users.find_by(user_id: current_user[:id])
          opponent_register = registered_users.where.not(user_id: current_user[:id]).first
          
            if current_user_register == nil
              render json: {
                status: 400,
                message: 'user not registered in quiz'
              }, status: :bad_request
              return
            end

          render json: {
            status: 200,
            message: 'result fetched!',
            data: {
              userPerformance: current_user_register[:performance],
              opponentPerformance: opponent_register[:performance],
              userTimeSpent:current_user_register[:time_spent],
              opponentTimeSpent:opponent_register[:time_spent],
              result:current_user_register[:result]
            }
          }, status: :ok
        rescue StandardError => ex
          render json: {
            status: 'error to get quiz result',
            message: ex.to_s
          }, status: :bad_request
        end        
      end
      
      def finish_course_battle
        begin
          registered_users = CourseBattleUser
                               .select(:result, :performance, :time_spent, :user_id)
                               .where(course_battle_id: params[:courseBattleId].to_s)
      
          current_user_register = registered_users.find_by(user_id: current_user[:id])
          opponent_register = registered_users.where.not(user_id: current_user[:id]).first
      
          unless current_user_register
            render json: { status: 400, message: 'User not registered in quiz' }, status: :bad_request
            return
          end
      
          if current_user_register.result != 'not-finished' && current_user_register.performance.present?
            render json: { status: 400, message: 'User already finished quiz battle' }, status: :bad_request
            return
          end
      
          if opponent_register && opponent_register.result == 'awaiting-opponent'
            user_performance = calculate_user_performance
            opponent_performance = opponent_register.performance
      
            result, opponent_result = determine_results(user_performance, opponent_performance)
      
            update_course_battle_user(current_user[:id], params[:courseBattleId], result, user_performance, params[:timeSpent])
            update_course_battle_user(opponent_register.user_id, params[:courseBattleId],  opponent_result, opponent_performance, params[:timeSpent])
      
            render json: build_response(result, user_performance, opponent_performance), status: :ok
            return
          end
      
          user_performance = calculate_user_performance
          update_course_battle_user(current_user[:id], params[:courseBattleId], 'awaiting-opponent', user_performance, params[:timeSpent])
          broadcast_opponent_finished
      
          render json: build_waiting_response(user_performance), status: :ok
        rescue StandardError => e
          render json: { status: 'error finishing quiz battle', message: e.to_s }, status: :bad_request
        end
      end
      
      private
      
      def determine_results(user_performance, opponent_performance)
        if user_performance > opponent_performance
          ['won', 'lost']
        elsif opponent_performance > user_performance
          ['lost', 'won']
        else
          ['draw', 'draw']
        end
      end
      
      def update_course_battle_user(user_id, battle_id, result, performance = nil, time_spent = nil)
        CourseBattleUser.find_by(user_id: user_id, course_battle_id: battle_id)
                        .update(result: result, performance: performance, time_spent: time_spent)
      end
      
      def build_response(result, user_performance, opponent_performance)
        {
          status: 200,
          message: "User #{result} this quiz battle",
          data: {
            userPerformance: user_performance,
            opponent_performance: opponent_performance,
            result: result
          }
        }
      end
      
      def build_waiting_response(user_performance)
        {
          status: 200,
          message: 'Successfully finished, waiting for opponent to finish!',
          data: {
            userPerformance: user_performance,
            result: 'awaiting-opponent'
          }
        }
      end
      
      def broadcast_opponent_finished
        ActionCable.server.broadcast(
          "course_battle_chat_#{params[:courseBattleId]}",
          {
            userId: current_user.id,
            name: current_user.name,
            avatar: current_user.avatar,
            courseBattleId: params[:courseBattleId],
            type: "opponent_finished_quiz_battle"
          }
        )
      end
      
      
      def get_course_battle_alternatives(question_ids, user_id, course_battle_id)
        user_alternatives = UserAlternative.select(
					'id, 
					user_id as userId, 
					question_id as questionId,
					question_alternative_id as questionAlternativeId,id, 
					course_battle_id as courseBattleId, 
					created_at as createdAt').where(question_id: question_ids, user_id:user_id, course_battle_id:course_battle_id)
          
          return user_alternatives
      end
      
      def calculate_user_performance
        questions_count = CourseQuestion.where(course_id: params['courseId']).count

        chosen_alternative_ids = params['userChosenAlternatives'].map { |hash| hash["id"] }

        right_alternatives_count = QuestionAlternative.where(id: chosen_alternative_ids, is_right: true).count

        if questions_count > 0
          user_performance = (right_alternatives_count * 100.0) / questions_count
        else
          user_performance = 0
        end
        
        return user_performance
      end
        
      def course_battle_creation_params
        params.permit(:name, :courseId, :userId)
      end      
    end
  end
end
