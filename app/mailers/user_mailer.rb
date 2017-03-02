class UserMailer < ActionMailer::Base
  default from: "Winnitron Network <winnitron.network@gmail.com>"

  layout "mail"

  def request_builder_status(user)
    @user = user
    mail(to: ENV["BUILDER_REQUEST_RECIPIENT"], subject: "Request for builder status") do  |format|
      format.html { render "mailers/request_builder_status" }
    end

  end

end