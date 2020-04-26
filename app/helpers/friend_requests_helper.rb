module FriendRequestsHelper
	def user_received_request_count
		current_user.received_requests.count
	end
end
