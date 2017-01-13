class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dash, :request_builder]

  def index
    if user_signed_in?
      redirect_to(dash_path)
    else
      render "pages/index", layout: "outside"
    end
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