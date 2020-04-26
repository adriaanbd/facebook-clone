module UserStatus
	extend ActiveSupport::Concern

  def set_user
  	@user = User.find_by(username: params[:username])
  end

  def not_current_user?
  	current_user != @user
  end

  def is_current_user?
    current_user == @user
  end

  def not_signed_in?
    !user_signed_in?
  end
end