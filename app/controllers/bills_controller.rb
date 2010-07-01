class BillsController < ApplicationController
  def index
    @bills = Bill.all(:include => :ratings)
  end
end
