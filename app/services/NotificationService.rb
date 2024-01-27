
module Api
  module V1
    class NotificationService
      def self.create_notification(notifier_id, notified_id, type_id)
        notification = user.notifications.create(
                                                  notification_type_id: type_id,
                                                  is_read: false,
                                                  notifier_id: notifier_id,
                                                  notified_id: notified_id
                                                )
        
        notification.save!
        
        notification
    
      end
  end
end
