class UserMailer < ActionMailer::Base
  default from: "Winnitron Network <winnitron.support@outerspacehero.com>"

  layout "mail"

  def request_builder_status(user)
    @user = user
    mail(to: "winnitron.support@outerspacehero.com", subject: "Request for builder status") do  |format|
      format.html { render "mailers/request_builder_status" }
    end

  end

end