class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @fb_user = User.from_omniauth(request.env["omniauth.auth"])
    @user = User.find_by(email: @fb_user.email)
    if @user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      # session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_path
      set_flash_message(:alert, :failure, kind: "Facebook", reason: "you need to sign up")
    end
  end

  def failure
    redirect_to root_path
  end
end