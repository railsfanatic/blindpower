class AddInfoToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :short_title, :string
    add_column :bills, :official_title, :string
    add_column :bills, :summary, :text
    add_column :bills, :sponsor_id, :integer
    add_column :bills, :last_action_on, :date
    add_column :bills, :last_action_text, :text
    add_column :bills, :enacted_on, :date
    add_column :bills, :average_rating, :float, :null => false, :default => 0
    add_column :bills, :deleted_at, :datetime
    add_column :bills, :deleted_by, :integer
    
    create_table :bills_cosponsors, :id => false do |t|
      t.integer :bill_id
      t.integer :legislator_id
    end
  end

  def self.down
    drop_table :bills_cosponsors
    
    remove_column :bills, :deleted_by
    remove_column :bills, :deleted_at
    remove_column :bills, :average_rating
    remove_column :bills, :enacted_on
    remove_column :bills, :last_action_text
    remove_column :bills, :last_action_on
    remove_column :bills, :sponsor_id
    remove_column :bills, :summary
    remove_column :bills, :official_title
    remove_column :bills, :short_title
  end
end
