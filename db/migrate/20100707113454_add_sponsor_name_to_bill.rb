class AddSponsorNameToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :sponsor_name, :string
    
    Bill.reset_column_information
    Bill.all.each do |bill|
      bill.update_all(:sponsor_name => bill.sponsor.last_name, :id => bill.id)
    end
  end

  def self.down
    remove_column :bills, :sponsor_name
  end
end
