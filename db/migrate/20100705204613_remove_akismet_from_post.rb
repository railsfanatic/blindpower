class RemoveAkismetFromPost < ActiveRecord::Migration
  def self.up
    remove_column :posts, :approved
    remove_column :posts, :user_ip
    remove_column :posts, :user_agent
    remove_column :posts, :referer
  end

  def self.down
    add_column :posts, :referer, :string
    add_column :posts, :user_agent, :string
    add_column :posts, :user_ip, :string
    add_column :posts, :approved, :boolean
  end
end
