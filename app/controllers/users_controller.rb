class UsersController < ApplicationController

  def show
    @title = "Show"
    @user = User.find(params[:id])
    #debugger       デバッグに有効
  end

  def new
    @title = "Sign up"
  end
end
