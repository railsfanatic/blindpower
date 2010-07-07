class PostsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]
  before_filter :ensure_app_admin, :only => [:destroy_multiple]
  before_filter :find_authorized, :only => [:edit, :update, :destroy]
  
  def index
    @posts = Post.published.all(:limit => 20)
    @post_months = @posts.group_by { |p| p.created_at.beginning_of_day }
  end
  
  def show
    if admin?
      @post = Post.find(params[:id])
    elsif current_user
      @post = Post.find(params[:id], :joins => :user, :conditions => ["posts.user_id = ? OR users.author = ?", current_user.id, true])
    else
      @post = Post.published.find(params[:id])
    end
    @comment = @post.comments.new
  end
  
  def new
    @post = current_user.posts.new
  end
  
  def create
    @post = current_user.posts.new(params[:post])
    if @post.save
      flash[:notice] = "Thanks for posting!"
      redirect_to :back
    else
      render :action => 'new'
    end
  end
  
  def edit
    @post = Post.find(params[:id])
    unless admin? || @post.user == current_user
      flash[:error] = "Unauthorized!"
      redirect_to posts_path
    end
  end
  
  def update
    #params[:post][:tag_ids] ||= []
    @post = Post.find(params[:id])
    if admin? || @post.user == current_user
      if @post.update_attributes(params[:post])
        @post.update_attribute(:deleted_at, nil)
        flash[:notice] = "Successfully updated post."
        redirect_to :back
      else
        render :action => 'edit'
      end
    else
      flash[:error] = "Unauthorized!"
      redirect_to :back
    end
  end
  
  def destroy
    # only marks as deleted -- app_admin can destroy_multiple
    @post = Post.find(params[:id])
    if admin? || @post.user == current_user
      @post.update_attribute(:deleted_at, Time.now)
      @post.update_attribute(:deleted_by, current_user.id)
      flash[:notice] = "Successfully marked post as deleted."
      redirect_to posts_path
    else
      flash[:error] = "Unauthorized!"
      redirect_to @post
    end
  end
  
  def destroy_multiple
    if params[:post_ids].length
      Post.destroy_all(:id => params[:post_ids])
      flash[:notice] = "Successfully destroyed #{params[:post_ids].length} Post(s)."
    else
      flash[:error] = "No Post(s) selected."
    end
    redirect_to posts_path
  end
  
  private
  
  def find_authorized
    @post = Post.find(params[:id])
    unless admin? || @post.user == current_user
      flash[:error] = "Unauthorized!"
      redirect_to posts_path
    end
  end
end
