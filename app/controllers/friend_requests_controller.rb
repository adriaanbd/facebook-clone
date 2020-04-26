class FriendRequestsController < ApplicationController
  before_action :set_user

  def create
    if user_signed_in?
      @friend_request = FriendRequest.new(requester: current_user, requestee: @user)
      @friend_request.save
      redirect_to profile_path(username: @user.username)
    end
  end

  def destroy
    if user_signed_in?
      @friend_request = FriendRequest.find_by(id: params[:id])
      @friend_request.destroy if valid_request?
      if session[:source] == 'profile'
        redirect_to profile_path(username: @user.username)
      else
        if current_user == @friend_request.requestee
          redirect_to requests_received_requests_path
        else
          redirect_to requests_sent_requests_path
        end
      end
    end
  end

  private 

  def valid_request?
    current_user == @friend_request.requester || current_user == @friend_request.requestee
  end
end