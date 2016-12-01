class Admin::UsersController < ApplicationController
  before_action :require_admin!

  def index
    @users = User.all.order(id: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "yep"
    else
      render :edit, warning: "There was a problem"
    end
  end


  private

  def user_params
    params.fetch(:user).permit(:name, :email, :builder)
  end
end