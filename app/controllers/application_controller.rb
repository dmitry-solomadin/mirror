class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def after_sign_in_path_for(resource)
    user = resource
    dashboard_path(user.dashboard)
  end
end
