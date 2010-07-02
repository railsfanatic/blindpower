class SuggestionsController < ApplicationController
  before_filter :authenticate
  
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
    @suggestion = current_user.suggestions.find(params[:id])
  end
  
  def update
    @suggestion = current_user.suggestions.find(params[:id])
    if @suggestion.update_attributes(params[:suggestion])
      flash[:notice] = "Successfully updated suggestion."
      redirect_to suggestions_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @suggestion = current_user.suggestions.find(params[:id])
    @suggestion.destroy
    flash[:notice] = "Successfully destroyed suggestion."
    redirect_to suggestions_url
  end
end
