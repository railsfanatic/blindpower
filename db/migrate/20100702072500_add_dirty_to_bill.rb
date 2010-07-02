class AddDirtyToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :dirty, :boolean, :null => false, :default => true
    
    Bill.reset_column_information
    
    Bill.update_all(:dirty => true)
  end

  def self.down
    remove_column :bills, :dirty
  end
end
