class AddDeletedToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :deleted_at, :datetime
    add_column :posts, :deleted_by, :integer
  end

  def self.down
    remove_column :posts, :deleted_by
    remove_column :posts, :deleted_at
  end
end
