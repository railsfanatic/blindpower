class AddPostIdToSuggestion < ActiveRecord::Migration
  def self.up
    add_column :suggestions, :post_id, :integer
  end

  def self.down
    remove_column :suggestions, :post_id
  end
end
