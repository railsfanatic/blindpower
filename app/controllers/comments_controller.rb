class CommentsController < ApplicationController
  before_filter :authenticate, :except => :index
  
  def index
    @approved_comments = Comment.recent(20, :approved => true)
    @rejected_comments = Comment.recent(100, :approved => false) if admin?
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def create
    @comment = current_user.comments.new(params[:comment])
    @comment.request = request
    if @comment.save
      if @comment.approved?
        flash[:notice] = "Thanks for the comment."
      else
        flash[:error] = "Unfortunately this comment is considered spam by Akismet. " + 
                        "It will show up once it has been approved by a moderator."
      end
      redirect_to @comment.post
    else
      render :action => 'new'
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
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to comments_path
  end
  
  def destroy_multiple
    if params[:comment_ids]
      Comment.destroy(params[:comment_ids])
      flash[:notice] = "Successfully destroyed comments."
    else
      flash[:error] = "No comments selected."
    end
    redirect_to comments_path
  end
  
  def approve
    @comment = Comment.find(params[:id])
    @comment.mark_as_ham!
    redirect_to comments_path
  end

  def reject
    @comment = Comment.find(params[:id])
    @comment.mark_as_spam!
    redirect_to comments_path
  end
end
