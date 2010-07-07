class LegislatorsController < ApplicationController
  def index
    @legislators = Legislator.paginate(:page => params[:page], :order => sort_order('last_name ASC'))
  end
  
  def show
    @legislator = Legislator.find(params[:id])
  end
end
