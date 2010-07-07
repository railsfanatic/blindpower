class CommentsController < ApplicationController
  before_filter :authenticate, :except => :index
  
  def index
    @commentable = find_commentable
    @comments = Comment.recent
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    
    if @comment.save
      flash[:notice] = "Thanks for the comment."
      redirect_to @commentable
    else
      redirect_to :back
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attribute(:content, params[:content])
      flash[:notice] = "Successfully updated comment."
      redirect_to @comment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    find_authorized
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to comments_path
  end
  
  private
  
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
end
