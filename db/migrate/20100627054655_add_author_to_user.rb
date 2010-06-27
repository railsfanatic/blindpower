class AddAuthorToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :author, :boolean
  end

  def self.down
    remove_column :users, :author
  end
end
