class AttractsController < ApplicationController
  before_action :set_arcade_machine
  before_action :authenticate_user!
  before_action :permission_check!

  def index
  end

  private

  def set_arcade_machine
    @arcade_machine = ArcadeMachine.find_by!(slug: params[:id])
  end

  def permission_check!
    require_admin_or_ownership!(@arcade_machine)
  end
end
