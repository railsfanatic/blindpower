class BillsController < ApplicationController
  before_filter :ensure_app_admin, :except => [:index, :show, :read, :summarize]
  
  def index
    @bills = Bill.visible.paginate(:page => params[:page], :include => [:ratings, :cosponsors], :order => sort_order('last_action_on DESC'))
    @hidden_bills = Bill.hidden if admin?
  end
  
  def show
    @bill = Bill.visible.find(params[:id], :include => [:sponsor, :cosponsors, :comments])
    @cosponsor_states = @bill.cosponsors.group_by { |c| c.state }
    @find_blind = @bill.find_blind
    @find_deafblind = @bill.find_deafblind
    @find_visually_impaired = @bill.find_visually_impaired
    @comment = @bill.comments.new
  end
  
  def read
    @bill = Bill.visible.find(params[:id])
  end
  
  def summarize
    @bill = Bill.visible.find(params[:id])
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
      render 'new'
    end
  end
  
  def update
    # Force bill to update
    @bill = Bill.find(params[:id])
    if @bill.update_attribute(:hidden, false)
      flash[:notice] = "Successfully updated bill."
    end
    redirect_to bills_path
  end
  
  def hide
    @bill = Bill.find(params[:id])
    @bill.update_attribute(:hidden, true)
    flash[:notice] = "Bill marked as hidden."
    redirect_to bills_path
  end
  
  def destroy
    @bill = Bill.find(params[:id])
    @bill.destroy
    flash[:notice] = "Successfully destroyed bill."
    redirect_to bills_path
  end
end
