class SuggestionsController < ApplicationController
  before_filter :authenticate
  
  def index
    @suggestions = Suggestion.all
    @suggestion_kinds = @suggestions.group_by { |s| s.kind }
    @suggestion = current_user.suggestions.new if current_user
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
    @suggestion = find_editable
  end
  
  def update
    @suggestion = find_editable
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
end
