class NotificationsController < ApplicationController

	def index
		redirect_to(root_path) if not_signed_in? 
		if user_signed_in?
			@notifications = current_user.notifications.order(created_at: :desc) 
			set_to_read(@notifications)
		end
	end

	private

	def set_to_read(notifs)
		notifs.where(['status = ? AND user_id = ?', 'Unread', current_user]).update(status: 'Read')
	end
end
