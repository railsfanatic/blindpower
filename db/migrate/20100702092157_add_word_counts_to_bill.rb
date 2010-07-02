class AddWordCountsToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :summary_word_count, :integer
    add_column :bills, :text_word_count, :integer
    add_column :bills, :blind_count, :integer
    add_column :bills, :deafblind_count, :integer
 end

  def self.down
    remove_column :bills, :deafblind_count, :integer
    remove_column :bills, :blind_count, :integer
    remove_column :bills, :text_word_count
    remove_column :bills, :summary_word_count
  end
end
