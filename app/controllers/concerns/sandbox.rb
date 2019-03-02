module Sandbox
  extend ActiveSupport::Concern

  def sandbox?
    params[:test].present? && params[:test].to_s != "0"
  end
end
