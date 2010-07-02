class AddCosponsorsCountToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :cosponsors_count, :integer, :default => 0
  end

  def self.down
    remove_column :bills, :cosponsors_count
  end
end
