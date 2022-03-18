class SessionsController < ApplicationController

  def new
  end

  def create
    if User.exists?(username: params[:username])
      user = User.find_by username: params[:username]
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to '/dashboard'
      else
        flash.now[:error] = "Error: Invalid username or password."
        render :new
      end
    else
      flash.now[:error] = "Error: Invalid username or password."
      render :new
    end
  end

  def destroy
    session.destroy
    flash[:notice] = "Successfully logged out"
    redirect_to root_path
  end
end
