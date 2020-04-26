class HomeController < ApplicationController
  before_action { set_source('home') }

  def index
  	render :new if !user_signed_in?
  	@posts = current_user.home_posts.sort_by { |home_post| home_post.created_at }.reverse if user_signed_in?
  end
  
end