class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActiveSupport::MessageVerifier::InvalidSignature, with: :render_500

  layout :layout_by_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:website,
                                                              links_attributes: [:id, :link_type, :url, :_destroy]])
  end

  def require_admin_or_ownership!(object)
    if user_signed_in? && (current_user.admin? || current_user.owns?(object))
      true
    else
      head :forbidden
    end
  end

  def require_builder!
    if user_signed_in? && (current_user.admin? || current_user.builder?)
      true
    else
      redirect_to request_builder_path
    end
  end

  def require_admin!
    if user_signed_in? && current_user.admin?
      true
    else
      render_404
    end
  end

  def render_404
    render file: 'public/404.html', status: 404, layout: false
  end

  def render_500
    render file: 'public/500.html', status: 500, layout: false
  end

  private

  def layout_by_resource
    if devise_controller?
      "outside"
    else
      "application"
    end
  end
end
