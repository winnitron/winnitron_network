class AttractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attract, except: [:new, :create]
  before_action :permission_check!, except: [:new]

  def new
    @attract = Attract.new
  end

  def edit
  end

  def create
    @attract = Attract.new(attract_params)
    if @attract.save
      redirect_to dash_arcade_machine_path(@attract.arcade_machine), notice: "Attract message added."
    else
      render :edit
    end
  end

  def update
    if @attract.update(attract_params)
      redirect_to dash_arcade_machine_path(@attract.arcade_machine), notice: "Attract message updated."
    else
      render :edit
    end
  end

  def destroy
    require_admin_or_ownership!(@attract.arcade_machine)

    if @attract.destroy
      redirect_to dash_arcade_machine_path(@attract.arcade_machine), notice: "Attract message removed."
    else
      redirect_to dash_arcade_machine_path(@attract.arcade_machine), error: "Error removing attract message."
    end
  end

  private

  def set_attract
    @attract = Attract.find(params[:id])
  end

  def permission_check!
    id = params.dig(:attract, :arcade_machine_id)
    machine = id ? ArcadeMachine.find(id) : @attract.arcade_machine
    require_admin_or_ownership!(machine)
  end

  def attract_params
    params.require(:attract).permit(:text, :starts_at, :arcade_machine_id, :ends_at)
  end
end
