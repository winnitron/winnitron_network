class PagesController < ApplicationController
  def index
    redirect_to(dash_path) if user_signed_in?
  end

  def dash
  end

  def request_builder
  end

  def feedback
  end
end