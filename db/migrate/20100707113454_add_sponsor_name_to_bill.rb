class AddSponsorNameToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :sponsor_name, :string
  end

  def self.down
    remove_column :bills, :sponsor_name
  end
end
