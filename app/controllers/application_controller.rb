class ApplicationController < ActionController::Base
  helper_method :current_user

private

  def error_message(errors)
    errors.full_messages.join(', ')
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if !current_user
      flash[:alert] = "You must be logged in to access this page."
      redirect_to root_path
    end
  end
end
