class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      unless session[:url].blank?
        redirect_to session[:url]
        session.delete :url
      else
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end

end
