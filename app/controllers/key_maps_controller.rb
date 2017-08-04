class KeyMapsController < ApplicationController

  def index
    render json: KEY_MAP_TEMPLATES
  end

end
