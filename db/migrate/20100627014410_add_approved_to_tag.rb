class AddApprovedToTag < ActiveRecord::Migration
  def self.up
    add_column :tags, :approved, :boolean, :default => false, :null => :false
  end

  def self.down
    remove_column :tags, :approved
  end
end
