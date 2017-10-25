class ArcadeMachinesController < ApplicationController
  before_action :set_arcade_machine, except: [:index, :new, :create, :map]
  before_action :authenticate_user!, except: [:index, :show, :map]
  before_action :permission_check!, only: [:edit, :update, :destroy, :images, :confirm_destroy]
  before_action only: [:show] do
    require_approval!(@arcade_machine)
  end

  def index
    @arcade_machines = ArcadeMachine.approved
  end

  def show
  end

  def new
    @arcade_machine = ArcadeMachine.new
  end

  def edit
  end

  def images
  end

  def create
    @arcade_machine = ArcadeMachine.new(arcade_machine_params)
    @arcade_machine.users    << current_user
    @arcade_machine.api_keys << ApiKey.new

    if @arcade_machine.save
      redirect_to images_arcade_machine_path(@arcade_machine.slug)
    else
      render :new
    end
  end

  def update
    if @arcade_machine.update(arcade_machine_params)
      redirect_to @arcade_machine, notice: 'Arcade machine was successfully updated.'
    else
      render :edit
    end
  end

  def confirm_destroy
    @to_destroy = @arcade_machine
    render "shared/confirm_destroy"
  end

  def destroy
    @arcade_machine.destroy
    respond_to do |format|
      format.html { redirect_to arcade_machines_url, notice: 'Arcade machine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def map
    @markers = ArcadeMachine.approved.geocoded.map do |am|
      {
        lat: am.latitude,
        lng: am.longitude
      }
    end
  end

  private
    def set_arcade_machine
      @arcade_machine = ArcadeMachine.find_by!(slug: params[:id])
    end

    def permission_check!
      require_admin_or_ownership!(@arcade_machine)
    end

    def arcade_machine_params
      params.fetch(:arcade_machine, {}).permit(:title, :description, :location, :players, :mappable,
                                               links_attributes: [:id, :link_type, :url, :_destroy])
    end

end
