class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id
      t.integer :commentable_id
      t.string :commentable_type
      t.text :content
      t.string :user_ip
      t.string :user_agent
      t.string :referer
      t.boolean :approved, :default => false, :null => false
      t.integer :position
      t.timestamps
    end
  end
  
  def self.down
    drop_table :comments
  end
end
