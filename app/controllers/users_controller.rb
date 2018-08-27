class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only: [:edit, :show, :update]
  def index
    @users = User.active.paginate(page: params[:page])
  end

  def show
    redirect_to root_url && return unless FILL_IN
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controller.user.create.info"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "controller.user.update.flash"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  def destroy
    if User.find_by(params[:id]).try(:destroy)
      flash[:success] = t "controller.user.destroy.success"
      redirect_to users_url
    else
      flash[:danger] = t "controller.user.destroy.danger"
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controller.user.login_user.danger"
    redirect_to login_url
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_user
    @user = User.find_by(params[:id])
    return if @user.present?
    render html: "Empty record"
  end
end
