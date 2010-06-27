class PostsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]
  
  def index
    @posts = Post.approved(20)
    @rejected_posts = Post.recent(100, :approved => false) if admin?
    @post_months = @posts.group_by { |p| p.created_at.beginning_of_day }
  end
  
  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.new
  end
  
  def new
    @post = current_user.posts.new
  end
  
  def create
    @post = current_user.posts.new(params[:post])
    @post.request = request
    if @post.save
      if @post.approved?
        flash[:notice] = "Thanks for posting!"
      else
        flash[:error] = "Unfortunately this post is considered spam by Akismet. " + 
                        "It will show up once it has been approved by a moderator."
      end
      redirect_to @post
    else
      render :action => 'new'
    end
  end
  
  def edit
    @post = Post.find(params[:id])
    unless admin? || @post.user == current_user
      flash[:error] = "Unauthorized!"
      redirect_to @post
    end
  end
  
  def update
    params[:post][:tag_ids] ||= []
    @post = Post.find(params[:id])
    if admin? || @post.user == current_user
      if @post.update_attributes(params[:post])
        flash[:notice] = "Successfully updated post."
        redirect_to @post
      else
        render :action => 'edit'
      end
    else
      flash[:error] = "Unauthorized!"
      redirect_to @post
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    if admin? || @post.user == current_user
      @post.destroy
      flash[:notice] = "Successfully destroyed post."
      redirect_to posts_url
    else
      flash[:error] = "Unauthorized!"
      redirect_to @post
    end
  end
end
