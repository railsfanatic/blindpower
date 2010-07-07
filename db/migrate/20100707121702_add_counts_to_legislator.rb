class AddCountsToLegislator < ActiveRecord::Migration
  def self.up
    add_column :legislators, :sponsored_count, :integer, :default => 0
    add_column :legislators, :cosponsored_count, :integer, :default => 0
    
    Legislator.reset_column_information
    Legislator.all.each do |l|
      l.update_attribute :sponsored_count, l.sponsored.length
      l.update_attribute :cosponsored_count, l.cosponsored.length
    end
  end

  def self.down
    remove_column :legislators, :cosponsored_count
    remove_column :legislators, :sponsored_count
  end
end
