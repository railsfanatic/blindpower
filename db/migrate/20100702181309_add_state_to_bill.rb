class AddStateToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :state, :string
    add_column :bills, :text_updated_on, :date
    remove_column :bills, :status
    remove_column :bills, :title
  end

  def self.down
    remove_column :bills, :text_updated_on
    remove_column :bills, :state
  end
end
