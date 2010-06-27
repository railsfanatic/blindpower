class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create, :show]
  before_filter :ensure_app_admin, :only => [:index, :update_multiple]
  
  def index
    @users = User.all(:order => "created_at DESC")
  end
  
  def new
    @user = User.new
    session[:captcha_value] = 10 + rand(90)
  end
  
  def create
    @user = User.new(params[:user])
    captcha_value = session[:captcha_value]
    session[:captcha_value] = 10 + rand(90)
    if params[:my_number].to_s != captcha_value.to_s
      @user.errors.add "Human validation"
      render :action => 'new'
    elsif @user.save
      flash[:notice] = "Registration successful!"
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def update_multiple
    User.update_all(:author => false, :admin => false)
    User.update_all(["author = ?", true], :id => params[:author_ids]) if params[:author_ids]
    User.update_all(["admin = ?", true], :id => params[:admin_ids]) if params[:admin_ids]
    flash[:notice] = "Successfully updated users."
    redirect_to users_path
  end
end
