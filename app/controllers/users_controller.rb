class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:send_builder_request]

  def show
    @user = User.find(params[:id])
  end
end