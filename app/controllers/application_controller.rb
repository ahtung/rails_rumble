class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  before_action :check_screenshot

  def after_sign_in_path_for(resource)
    organizations_path
  end

  private

  def check_screenshot
    if params[:screenshot].present? && params[:screenshot] == 'true'
      render template: 'pages/screenshot'
    end
  end
end
