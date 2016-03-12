class UsersController < ApplicationController

  def show
    @title = "Show"
    @user = User.find(params[:id])
    #debugger       デバッグに有効
  end

  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcom to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
    end
end
