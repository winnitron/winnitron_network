class InstallationsController < ApplicationController
  before_action :set_arcade_machine
  before_action :permission_check!

  def create
    (params[:games] || []).each do |game_id|
      Installation.find_or_create_by game_id: game_id, arcade_machine: @arcade_machine
    end

    redirect_to games_path, notice: "Game(s) added"
  end

  def destroy
    @install = Installation.find(params[:id])
    @install.destroy
    respond_to do |format|
      format.html { redirect_to @install.arcade_machine, notice: 'Game removed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_arcade_machine
    @arcade_machine = if params[:target_id]
      ArcadeMachine.find(params[:target_id].sub("am-", ""))
    else
      Installation.find(params[:id]).arcade_machine
    end
  end


  def permission_check!
    require_admin_or_ownership!(@arcade_machine)
  end

end