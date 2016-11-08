class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:destroy]
  before_action :set_playlist
  before_action :set_arcade_machine
  before_action :permission_check!

  def create
    subscription = Subscription.find_by playlist: @playlist, arcade_machine: @arcade_machine
    if subscription
      render json: subscription, status: :ok
    else
      subscription = Subscription.create(playlist: @playlist, arcade_machine: @arcade_machine)
      render json: subscription, status: :created
    end
  end

  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to @arcade_machine, notice: "Unsubscribed from #{@subscription.playlist.title}." }
      format.json { head :no_content }
    end
  end

  private

  def set_playlist
    @playlist = Playlist.find_by(id: params[:playlist_id]) || @subscription.playlist
  end

  def set_arcade_machine
    @arcade_machine = ArcadeMachine.find_by(id: params[:arcade_machine_id]) || @subscription.arcade_machine
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def permission_check!
    require_admin_or_ownership!(@arcade_machine)
  end

end