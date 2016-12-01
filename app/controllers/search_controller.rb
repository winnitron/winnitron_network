class SearchController < ApplicationController

  def index
    @games = Search.new(Game, params[:kw]).results
  end

end