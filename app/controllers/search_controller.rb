class SearchController < ApplicationController

  def index
    @games = Search.new(Game, params.fetch(:kw, ''), current_user).results
  end

end
