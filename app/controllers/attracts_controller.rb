class AttractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attract, except: [:new]
  before_action :permission_check!, except: [:new]

  def new
    @attract = Attract.new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_attract
    @attract = Attract.find(params[:id])
  end

  def permission_check!
    require_admin_or_ownership!(@attract.arcade_machine)
  end

  def attract_params
    params.require(:attract).permit(:text, :starts_at, :ends_at)
  end
end
