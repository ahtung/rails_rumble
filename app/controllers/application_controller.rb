class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  def after_sign_in_path_for(resource)
    organization_path(resource.organizations.first)
  end
end
