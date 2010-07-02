class CreateSuggestions < ActiveRecord::Migration
  def self.up
    create_table :suggestions do |t|
      t.integer :user_id
      t.string :kind, :required => true
      t.string :content, :limit => 140
      t.datetime :deleted_at
      t.timestamps
    end
    
    add_index :suggestions, :kind
  end
  
  def self.down
    drop_table :suggestions
  end
end
