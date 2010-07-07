class AddHiddenToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :hidden, :boolean, :default => false
    
    Bill.reset_column_information
    Bill.update_all(:hidden => :true, :conditions => "deleted_at IS NOT NULL")
    
    remove_column :bills, :deleted_at
  end
  
  def self.down
  end
end
