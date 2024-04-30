class SessionsController < ApplicationController
  
  def create
    auth = request.env['omniauth.auth']
    Rails.logger.debug(auth)
    if user = User.where(email: auth.info.email).first
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to root_path, notice: 'Access denied.'
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end