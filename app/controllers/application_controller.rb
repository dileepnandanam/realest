class ApplicationController < ActionController::Base
  #before_action :set_https
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:contact_number, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:contact_number, :name])
  end

  def set_https
    if Rails.env != "development"
      unless request.url.starts_with?('https')
        redirect_to request.url.gsub('http', 'https') and return
      end
    end
  end

  def authorize
    unless current_user
      render plain: 'unauthorized' and return
    end
  end


  def after_sign_in_path_for(resource)
    after_sign_path = session[:after_sign_path]
    session[:after_sign_path] = nil
    after_sign_path || root_path
  end

  def after_sign_up_path_for(resource)
    after_sign_path = session[:after_sign_path]
    session[:after_sign_path] = nil
    after_sign_path || root_path
  end
end
