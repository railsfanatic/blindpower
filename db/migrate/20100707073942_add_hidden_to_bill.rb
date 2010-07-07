class AddHiddenToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :bills, :hidden
  end
end
