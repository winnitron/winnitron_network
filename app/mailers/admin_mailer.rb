class AdminMailer < ActionMailer::Base
  default to:   ENV["ADMIN_EMAIL"],
          from: "Winnitron Network <winnitron.support@outerspacehero.com>"

  layout "mail"

  def alert_approval_request(approval_request)
    @approval_request = approval_request
    @user = @approval_request.approvable.users.first

    mail(subject: "Winnitron approval request") do  |format|
      format.html { render "mailers/alert_new_approval_request" }
    end
  end

end