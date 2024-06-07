module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate_user_request, only: [:index]

      def index
        begin
          notifications = Notification.joins(:notification_type)
                                      .joins("INNER JOIN users ON users.id = notifications.notifier_id")
                                      .select("
                                             notifications.id,
                                             notification_types.name as type, 
                                             notifier_id as notifierId, 
                                             users.name as notifierName,
                                             notified_id as notifiedId, 
                                             is_read as isRead")
                                             .where("notified_id = :user_id", user_id: current_user[:id].to_i)
                                             
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
