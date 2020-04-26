class Requests::ReceivedRequestsController < ApplicationController

	def index
		redirect_to(root_path) if not_signed_in? 
		@requesters = current_user.received_requests if user_signed_in?
	end
end
