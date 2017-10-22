class Admin::ApprovalRequestsController < ApplicationController
  before_action :require_admin!

  def index
    @approval_requests = ApprovalRequest.pending.order(updated_at: :desc)
  end

  def edit
    @approval_request = ApprovalRequest.find(params[:id])
  end

  def update
    @approval_request = ApprovalRequest.find(params[:id])
    @approval_request.update(approved_at: Time.now.utc)
    # TODO: notification
    redirect_to edit_admin_approval_request_path(@approval_request), notice: "Request approved"
  end

end