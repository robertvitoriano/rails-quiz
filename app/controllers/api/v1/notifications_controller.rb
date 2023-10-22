module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate_user_request, only: [:index]

      def index
        begin
          notifications = Notification.select("id, 
                                             notifier_id, 
                                             notified_id, 
                                             notification_type_id, 
                                             is_read")
                                             .where("notified_id = :user_id", user_id: current_user_id.to_i)
                                             
          render json: {status:'SUCCESS', message:'notifications found!', data: notifications}, status: :ok
          
        rescue  Exception => ex
          render json: {status:'Cannot get notifications, internal server error', message:ex}, status: :internal_server_error
        end
      end

     def get_notifications_params
      params.permit(:userId)
     end

    end
  end
end
