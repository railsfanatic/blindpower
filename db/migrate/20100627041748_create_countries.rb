class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name

      t.timestamps
    end
    add_column :users, :country_id, :integer
  end

  def self.down
    drop_table :countries
  end
end
