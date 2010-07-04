class AddStylesheetToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :stylesheet, :string, :default => "default"
  end

  def self.down
    remove_column :users, :stylesheet
  end
end
