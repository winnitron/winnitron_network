class ArcadeMachinesController < ApplicationController
  before_action :set_arcade_machine, only: [:show, :edit, :update, :destroy]

  def index
    @arcade_machines = ArcadeMachine.all
  end

  def show
  end

  def new
    @arcade_machine = ArcadeMachine.new
  end

  def edit
  end

  def create
    @arcade_machine = ArcadeMachine.new(arcade_machine_params)

    respond_to do |format|
      if @arcade_machine.save
        format.html { redirect_to @arcade_machine, notice: 'Arcade machine was successfully created.' }
        format.json { render :show, status: :created, location: @arcade_machine }
      else
        format.html { render :new }
        format.json { render json: @arcade_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @arcade_machine.update(arcade_machine_params)
        format.html { redirect_to @arcade_machine, notice: 'Arcade machine was successfully updated.' }
        format.json { render :show, status: :ok, location: @arcade_machine }
      else
        format.html { render :edit }
        format.json { render json: @arcade_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @arcade_machine.destroy
    respond_to do |format|
      format.html { redirect_to arcade_machines_url, notice: 'Arcade machine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_arcade_machine
      @arcade_machine = ArcadeMachine.find(params[:id])
    end

    def arcade_machine_params
      params.fetch(:arcade_machine, {}).permit(:name, :description, :location)
    end
end
