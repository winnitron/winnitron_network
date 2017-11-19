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

  def alert_new_stuff(since)
    @since = since.days.ago
    @machines = ArcadeMachine.where("created_at >= ?", @since)
    @games = Game.where("created_at >= ?", @since)
    @people = User.where("created_at >= ?", @since)
    @comments = Comment.where("created_at >= ?", @since)

    User.admins.find_each do |admin|
      mail(to: admin.email, subject: "New stuff this week on the Winnitron Network") do  |format|
        format.html { render "mailers/alert_new_stuff" }
      end
    end
  end

end
