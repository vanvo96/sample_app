class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == Setting.controll.session.create.prams ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = t "controller.sess.create.flash"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
