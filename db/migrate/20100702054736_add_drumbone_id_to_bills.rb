class AddDrumboneIdToBills < ActiveRecord::Migration
  def self.up
    rename_column :bills, :guid, :drumbone_id
    add_column :bills, :govtrack_id, :string, :null => false
    add_column :bills, :bill_html, :text, :null => false
    add_index :bills, :govtrack_id
  end

  def self.down
    remove_column :bills, :bill_html
    remove_column :bills, :govtrack_id
    rename_column :bills, :drumbone_id, :guid
  end
end
