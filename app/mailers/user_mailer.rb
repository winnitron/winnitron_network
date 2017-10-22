class UserMailer < ActionMailer::Base
  default from: "Winnitron Network <winnitron.support@outerspacehero.com>"

  layout "mail"

  def request_approved(approval_request)
    @approval_request = approval_request
    @user = @approval_request.approvable.users.first

    mail(to: "aklaassen@gmail.com", subject: "Your Winnitron approval request has been approved") do  |format|
      format.html { render "mailers/request_approved" }
    end
  end

end