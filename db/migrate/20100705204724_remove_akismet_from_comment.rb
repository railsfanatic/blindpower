class RemoveAkismetFromComment < ActiveRecord::Migration
  def self.up
    remove_column :comments, :approved
    remove_column :comments, :user_ip
    remove_column :comments, :user_agent
    remove_column :comments, :referer
  end

  def self.down
    add_column :comments, :referer, :string
    add_column :comments, :user_agent, :string
    add_column :comments, :user_ip, :string
    add_column :comments, :approved, :boolean
  end
end
