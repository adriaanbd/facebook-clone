class ProfilesController < ApplicationController
	before_action :set_user
	
	before_action only: [:show] do
		set_source('profile')
	end

  def show 
    @profile_posts = User.find_by(username: params[:username]).posts.order(created_at: :desc)
  end

  def edit
    redirect_to  action: 'show',
                 username: params[:username] if not_current_user?
  end
end
