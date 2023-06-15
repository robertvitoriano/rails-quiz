class UserNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_notification_#{params[:userId]}"
  end

  def unsubscribed
  end
end
