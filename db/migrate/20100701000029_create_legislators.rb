class CreateLegislators < ActiveRecord::Migration
  def self.up
    create_table :legislators do |t|
      t.string :first_name
      t.string :last_name
      t.integer :govtrack_id
      t.string :bioguide_id
      t.string :title
      t.string :nickname
      t.string :name_suffix
      t.integer :district
      t.string :state
      t.string :party

      t.timestamps
    end
    
    add_index :legislators, :bioguide_id
  end

  def self.down
    drop_table :legislators
  end
end
