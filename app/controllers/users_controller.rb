class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  def new
    @user = User.new
  end

  def login
  end

  def auth_user
    if User.exists?(username: params[:username])
      user = User.find_by username: params[:username]
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to "/dashboard"
      else
        redirect_to "/login"
        flash[:alert] = "Error: Invalid username or password."
      end
    else
      redirect_to "/login"
      flash[:alert] = "Error: Invalid username or password."
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      session[:user_id] = user.id
      redirect_to '/dashboard'
    elsif (params[:user][:password] != params[:user][:password_confirmation])
      redirect_to '/signup'
      flash[:error] = "Passwords don't match."
    else
      redirect_to '/signup'
      flash[:error] = "#{error_message(user.errors)}"
    end
  end

  def show
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
