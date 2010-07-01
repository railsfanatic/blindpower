class AddCosponsorsCountToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :cosponsors_count, :integer, :default => 0
    
    Bill.reset_column_information
    
    Bill.all.each do |p|
      p.update_attribute :cosponsors_count, p.cosponsors.length
    end
  end

  def self.down
    remove_column :bills, :cosponsors_count
  end
end
