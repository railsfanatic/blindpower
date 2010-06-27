class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean
    add_column :users, :condition_id, :integer
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :zip_code, :string
    add_column :users, :phone, :string
    add_column :users, :birthdate, :date
    add_column :users, :public, :string
    add_column :users, :intro, :text
  end

  def self.down
    remove_column :users, :intro
    remove_column :users, :public
    remove_column :users, :birthdate
    remove_column :users, :phone
    remove_column :users, :zip_code
    remove_column :users, :city
    remove_column :users, :address
    remove_column :users, :last_name
    remove_column :users, :first_name
    remove_column :users, :state_id
    remove_column :users, :country_id
    remove_column :users, :condition_id
    remove_column :users, :admin
  end
end
