module NotificationsHelper
	def user_notification_count
    current_user.notifications.where(['status = ?', 'Unread']).count
  end
end
