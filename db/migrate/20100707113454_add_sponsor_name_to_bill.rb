class AddSponsorNameToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :sponsor_name, :string
    
    Bill.reset_column_information
    Bill.all.each { |b| b.update_attribute(:sponsor_name, b.sponsor.last_name) }
  end

  def self.down
    remove_column :bills, :sponsor_name
  end
end
