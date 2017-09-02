class ApprovalRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_approvable

  def new
    @approval_request = ApprovalRequest.find_or_create_by!(approvable: @approvable)
  end

  def update
    @approval_request = @approvable.approval_request
    @approval_request.update(notes: params[:notes])
    redirect_to new_approval_request_path(@approvable), notice: "Thanks"
  end

  private

  def set_approvable
    klass = request.path.split("/")[1].singularize.camelcase.constantize # lol
    @approvable = klass.find_by!(slug: params[:id])
  end
end