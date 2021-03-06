class UsersController < ApplicationController
  before_filter :ensure_app_admin, :only => [:index, :update_multiple, :destroy]
  before_filter :authenticate, :except => [:new, :create, :show]
  before_filter :list_stylesheets, :only => [:new, :create, :edit, :update]
  
  def index
    @users = User.all(:order => "created_at DESC")
  end
  
  def show
    @user = User.find_by_username(params[:id])
    raise ActiveRecord::RecordNotFound, "Page not found" if @user.nil?
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
    if app_admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
  
  def update
    if app_admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def update_multiple
    User.update_all(:author => false, :admin => false)
    User.update_all(["author = ?", true], :id => params[:author_ids]) if params[:author_ids]
    User.update_all(["admin = ?", true], :id => params[:admin_ids]) if params[:admin_ids]
    flash[:notice] = "Successfully updated users."
    redirect_to users_path
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to users_path
  end
  
  private
  
  def list_stylesheets
    @stylesheets = Dir.glob('public/stylesheets/*.css').map!{ |file| File.basename(file, ".css") }.delete_if{ |f| f == "all" }
  end
end
