class RemoveLinkAndDirtyFromBill < ActiveRecord::Migration
  def self.up
    remove_column :bills, :link
    remove_column :bills, :dirty
  end

  def self.down
    add_column :bills, :dirty, :boolean
    add_column :bills, :link, :string
  end
end
