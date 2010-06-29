class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.string :guid
      t.integer :congress
      t.string :bill_type
      t.integer :bill_number
      t.text :title
      t.string :link
      t.string :status

      t.timestamps
    end
    
    add_index :bills, :guid
  end

  def self.down
    drop_table :bills
  end
end
