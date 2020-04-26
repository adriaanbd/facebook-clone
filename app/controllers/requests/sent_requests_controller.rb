class Requests::SentRequestsController < ApplicationController
	before_action { set_source('sent_requests') }

	def index
		redirect_to(root_path) if not_signed_in? 
		@requestees = current_user.sent_requests if user_signed_in?
	end
end
