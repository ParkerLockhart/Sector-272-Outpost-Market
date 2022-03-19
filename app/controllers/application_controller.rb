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

  def require_manager_user
    if current_user.role == "default"
      flash[:alert] = "You must have a merchant account to access this page."
      redirect_to '/dashboard'
    end
  end
end
