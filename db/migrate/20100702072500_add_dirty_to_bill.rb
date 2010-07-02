class AddDirtyToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :dirty, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :bills, :dirty
  end
end
