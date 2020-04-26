class FriendsController < ApplicationController
	before_action :set_user

  def index
  	if is_a_friend? || is_current_user?
  		@friends = @user.friends
  	else
  		redirect_to profile_path(@user.username) 
  	end
  end

  private 

  def is_a_friend?
  	@user.friends.include?(current_user)
  end
end
