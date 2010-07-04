# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :set_user_time_zone
  
  helper_method :current_user, :admin?, :app_admin?
  
  def sort_order(default)
    if params[:c]
      params[:c].to_s.gsub(/[\s;'\"]/,'') + " " + (params[:d] == 'down' ? 'DESC' : 'ASC')
    else
      default
    end
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def authenticate
    unless current_user
      session[:url] = request.url
      flash[:warning] = "Please log in to access this resource."
      redirect_to login_url
    end
  end
  
  def admin?
    current_user && current_user.admin?
  end
  
  def app_admin?
    current_user && current_user.email == "tom@grushka.com"
  end
  
  def ensure_admin
    unless admin?
      flash[:error] = "Unauthorized!"
      redirect_to root_url
    end
  end
  
  def ensure_app_admin
    unless app_admin?
      flash[:error] = "Unauthorized!"
      redirect_to root_url
    end
  end
  
  private

  def set_user_time_zone
    Time.zone = current_user.time_zone if current_user
  end
end
