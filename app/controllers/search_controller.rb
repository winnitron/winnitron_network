class SearchController < ApplicationController

  def index
    @games = Search.new(Game, params[:kw], current_user).results
  end

end