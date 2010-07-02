class BillsController < ApplicationController
  before_filter :ensure_admin, :only => [:new, :create, :update, :destroy]
  
  def index
    @bills = Bill.paginate(:page => params[:page], :include => [:ratings, :cosponsors], :conditions => {:deleted_at => nil}, :order => sort_order('last_action_on DESC'))
    @deleted_bills = Bill.all(:conditions => "deleted_at IS NOT NULL", :include => :ratings) if admin?
  end
  
  def show
    @bill = Bill.find(params[:id], :include => [:sponsor, :cosponsors, :comments])
    @cosponsor_states = @bill.cosponsors.group_by { |c| c.state }
    @find_blind = @bill.find_blind
    @find_deafblind = @bill.find_deafblind
    @find_visually_impaired = @bill.find_visually_impaired
    @comment = @bill.comments.new
  end
  
  def read
    @bill = Bill.find(params[:id])
  end
  
  def summarize
    @bill = Bill.find(params[:id])
  end
  
  def new
    @bill = Bill.new
  end
  
  def create
    @bill = Bill.new(params[:bill])
    if @bill.save
      flash[:notice] = "Successfully added Bill."
      redirect_to bills_path
    else
      render :action => 'new'
    end
  end
  
  def update
    # TODO: Add code to update single bill from web
    @bill = Bill.find(params[:id])
    if @bill.update_attribute(:deleted_at, nil)
      flash[:notice] = "Successfully undeleted bill."
    end
    redirect_to :back
  end
  
  def destroy
    @bill = Bill.find(params[:id])
    @bill.update_attribute(:deleted_at, Time.now)
    @bill.update_attribute(:deleted_by, current_user.id)
    flash[:notice] = "Bill marked as deleted."
    redirect_to bills_path
  end
end
