class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:send_builder_request]

  def show
    @user = User.find(params[:id])
  end

  def send_builder_request
    UserMailer.request_builder_status(current_user).deliver_now
    redirect_to dash_path, notice: "Winnitron-builder status requested. You'll hear back from us soon!"
  end
end