class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    save_oauth_token
    # TODO: (dunyakirkali) move to after save
    @user.fetch_organizations!
    sign_in_and_redirect @user
  end

  def save_oauth_token
    token = request.env["omniauth.auth"]["credentials"]["token"]
    @user.update_attribute(:oauth_token, token)
  end
end
