class AddHiddenToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :hidden, :boolean, :default => false
    
    Bill.reset_column_information
    Bill.update_all("hidden = 't'", "deleted_at IS NOT NULL")
    
    remove_column :bills, :deleted_at
  end
  
  def self.down
    add_column :bills, :deleted_at, :datetime
    
    Bill.reset_column_information
    Bill.update_all(["deleted_at = ?", Time.now.utc], ["hidden = ?", true])
    
    remove_column :bills, :hidden
  end
end
