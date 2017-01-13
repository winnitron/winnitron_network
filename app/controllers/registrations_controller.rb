class RegistrationsController < Devise::RegistrationsController
  layout "outside"

  def edit
    render :edit, layout: "application"
  end
end