class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.fetch_organizations!
    sign_in_and_redirect @user
  end

  def failure
    redirect_to root_path, notice: params[:message]
  end
end
