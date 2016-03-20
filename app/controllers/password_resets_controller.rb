class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only:[:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
    @title = "Forget password"
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructinos"
      redirect_to root_path
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
    @title = "Reset password"
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    #Beforeフィルタ

    def get_user
      @user = User.find_by(email: params[:email])
    end

    #正しいユーザーを確認する
    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    #再設定用トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
