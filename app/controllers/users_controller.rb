class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create, :show]
  
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
end
