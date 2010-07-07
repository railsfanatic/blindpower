class PostsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]
  
  def index
    @posts = Post.published.all(:limit => 20)
    @post_months = @posts.group_by { |p| p.created_at.beginning_of_day }
  end
  
  def show
    @post = find_showable :public_scope => "published"
    @comment = @post.comments.new
  end
  
  def new
    @post = current_user.posts.new
  end
  
  def create
    @post = current_user.posts.new(params[:post])
    if @post.save
      flash[:notice] = "Thanks for posting!"
      redirect_to posts_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @post = find_editable
  end
  
  def update
    #params[:post][:tag_ids] ||= []
    @post = find_editable
    if @post.update_attributes(params[:post])
      flash[:notice] = "Successfully updated post."
      redirect_to @post
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @post = find_editable
    @post.destroy
    flash[:notice] = "Successfully destroyed post."
    redirect_to posts_url
  end
  
  private
  
end
