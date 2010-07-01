class BillsController < ApplicationController
  before_filter :ensure_admin, :only => [:update, :destroy]
  
  def index
    @bills = Bill.paginate(:page => params[:page], :include => [:ratings, :cosponsors], :conditions => {:deleted_at => nil}, :order => sort_order('last_action_on DESC'))
    @deleted_bills = Bill.all(:conditions => "deleted_at IS NOT NULL", :include => :ratings)
  end
  
  def show
    @bill = Bill.find(params[:id])
    @comment = @bill.comments.new
  end
  
  def update
    @bill = Bill.find(params[:id])
    if @bill.update_attribute(:deleted_at, nil)
      flash[:notice] = "Successfully undeleted bill."
    end
    redirect_to :back
  end
  
  def destroy
    @bill = Bill.find(params[:id])
    @bill.update_attributes({:deleted_at => Time.now, :deleted_by => current_user.id})
    flash[:notice] = "Bill marked as deleted."
    redirect_to bills_url
  end
end
