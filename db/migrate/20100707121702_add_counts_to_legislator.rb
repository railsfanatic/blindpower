class AddCountsToLegislator < ActiveRecord::Migration
  def self.up
    add_column :legislators, :sponsored_count, :integer, :default => 0
    add_column :legislators, :cosponsored_count, :integer, :default => 0
    
    Legislator.reset_column_information
    say_with_time "Updating sponsored and cosponsored counts for legislators..." do
      Legislator.all.each do |legislator|
        legislator.update_attribute :sponsored_count, legislator.sponsored.length
        legislator.update_attribute :cosponsored_count, legislator.cosponsored.length
      end
    end
  end

  def self.down
    remove_column :legislators, :cosponsored_count
    remove_column :legislators, :sponsored_count
  end
end
