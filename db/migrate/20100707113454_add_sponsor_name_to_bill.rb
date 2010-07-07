class AddSponsorNameToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :sponsor_name, :string
    
    Bill.reset_column_information
    
    say_with_time "Updating bill sponsor_name cache column..." do
      Bill.all.each do |bill|
        unless bill.sponsor.nil?
          Bill.update_all(["sponsor_name = ?", bill.sponsor.last_name], ["id = ?", bill.id])
        end
      end
    end
  end
  
  def self.down
    remove_column :bills, :sponsor_name
  end
end
