class UsersController < ApplicationController

  def show
    @user = User.find_by id: params[:id]
    return if @user.present?
    render html: "Empty Record"
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "controller.user.create.flash"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
