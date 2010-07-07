class RollupTwo < ActiveRecord::Migration
  def self.up
    # table bills
    remove_column :bills, :link
    remove_column :bills, :dirty
    add_column :bills, :visually_impaired_count, :integer
    
    # table comments
    remove_column :comments, :approved
    remove_column :comments, :user_ip
    remove_column :comments, :user_agent
    remove_column :comments, :referer
    
    # table countries
    add_column :countries, :code, :string
    
    # table pages
    create_table :pages do |t|
      t.string :title
      t.string :permalink
      t.text :content
      t.timestamps
    end
    
    # table posts
    remove_column :posts, :approved
    remove_column :posts, :user_ip
    remove_column :posts, :user_agent
    remove_column :posts, :referer
    
    # table suggestions
    add_column :suggestions, :post_id, :integer
    
    # table users
    add_column :users, :stylesheet, :string, :default => "default"
    
    # table versions
    create_table :versions do |t|
      t.belongs_to :versioned, :polymorphic => true
      t.belongs_to :user, :polymorphic => true
      t.string :user_name
      t.text :changes
      t.integer :number
      t.string :tag
      t.timestamps
    end
    change_table :versions do |t|
      t.index [:versioned_id, :versioned_type]
      t.index [:user_id, :user_type]
      t.index :user_name
      t.index :number
      t.index :tag
      t.index :created_at
    end
  end

  def self.down
    # table versions
    drop_table :versions
    
    # table users
    remove_column :users, :stylesheet
    
    # table suggestions
    remove_column :suggestions, :post_id
    
    # table posts
    add_column :posts, :referer, :string
    add_column :posts, :user_agent, :string
    add_column :posts, :user_ip, :string
    add_column :posts, :approved, :boolean
    
    # table pages
    drop_table :pages
    
    # table countries
    
    # table comments
    add_column :comments, :referer, :string
    add_column :comments, :user_agent, :string
    add_column :comments, :user_ip, :string
    add_column :comments, :approved, :boolean
    
    # table bills
    remove_column :bills, :visually_impaired_count
    add_column :bills, :dirty, :boolean
    add_column :bills, :link, :string
  end
end
