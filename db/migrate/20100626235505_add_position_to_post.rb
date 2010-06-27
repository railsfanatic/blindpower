class AddPositionToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :position, :integer
    add_column :posts, :approved, :boolean, :default => true, :null => false
    add_column :posts, :user_ip, :string
    add_column :posts, :user_agent, :string
    add_column :posts, :referer, :string
  end

  def self.down
    remove_column :posts, :referer
    remove_column :posts, :user_agent
    remove_column :posts, :user_ip
    remove_column :posts, :approved
    remove_column :posts, :position
  end
end
