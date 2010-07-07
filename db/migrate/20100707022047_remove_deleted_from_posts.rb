class RemoveDeletedFromPosts < ActiveRecord::Migration
  def self.up
    Post.delete_all("deleted_at IS NOT NULL")
    remove_column :posts, :deleted_by
    remove_column :bills, :deleted_by
    remove_column :posts, :deleted_at
    remove_column :bills, :deleted_at
  end

  def self.down
    add_column :bills, :deleted_at, :datetime
    add_column :posts, :deleted_at, :datetime
    add_column :bills, :deleted_by, :integer
    add_column :posts, :deleted_by, :integer
  end
end
