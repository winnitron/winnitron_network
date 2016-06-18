class PagesController < ApplicationController
  def index
    redirect_to(games_path) if user_signed_in?
  end
end