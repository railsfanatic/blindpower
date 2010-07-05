class AddVisuallyImpairedCountToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :visually_impaired_count, :integer
  end

  def self.down
    remove_column :bills, :visually_impaired_count
  end
end
