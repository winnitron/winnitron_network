class PagesController < ApplicationController
  def index
    redirect_to(dash_path) if user_signed_in?

    render "pages/index", layout: "outside"
  end

  def dash
  end

  def request_builder
  end

  def feedback
  end

  def terms
  end
end