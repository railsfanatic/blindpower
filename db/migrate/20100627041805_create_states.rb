class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.integer :country_id
      t.string :name

      t.timestamps
    end
    add_column :users, :state_id, :integer
  end

  def self.down
    drop_table :states
  end
end
