class SuggestionsController < ApplicationController
  before_filter :authenticate
  before_filter :find_authorized, :only => [:create, :edit, :update, :destroy]
  
  def index
    @suggestions = Suggestion.all
    @suggestion_kinds = @suggestions.group_by { |s| s.kind }
  end
  
  def new
    @suggestion = current_user.suggestions.new
  end
  
  def create
    @suggestion = current_user.suggestions.new(params[:suggestion])
    if @suggestion.save
      flash[:notice] = "Successfully created suggestion."
      redirect_to suggestions_path
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @suggestion.update_attributes(params[:suggestion])
      flash[:notice] = "Successfully updated suggestion."
      redirect_to suggestions_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @suggestion.destroy
    flash[:notice] = "Successfully destroyed suggestion."
    redirect_to suggestions_url
  end
  
  private
  
  def find_authorized
    @suggestion = Suggestion.find(params[:id])
    unless admin? || @suggestion.user == current_user
      flash[:error] = "Unauthorized!"
      redirect_to suggestions_path
    end
  end
end
