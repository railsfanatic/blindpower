class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.integer :congress
      t.string :bill_type
      t.integer :bill_number
      t.text :title
      t.string :url
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
