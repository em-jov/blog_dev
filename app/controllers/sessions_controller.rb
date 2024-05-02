class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    if user = User.where(email: auth.info.email).first
      session[:user_id] = user.id
      redirect_to root_path, notice: "You've successfully logged in via #{auth.provider.titleize}."
    else
      redirect_to root_path, alert: 'Access denied. You are not authorized to log in.'
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  def failure
    redirect_to root_path, alert: 'Unable to authenticate with third party service.'
  end
end