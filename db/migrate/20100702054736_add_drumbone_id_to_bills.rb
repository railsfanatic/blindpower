class AddDrumboneIdToBills < ActiveRecord::Migration
  def self.up
    rename_column :bills, :guid, :drumbone_id
    add_column :bills, :govtrack_id, :string
    add_column :bills, :bill_html, :text
    
    Bill.reset_column_information
    
    Bill.all.each do |bill|
      bill.update_attribute :govtrack_id, govtrack_id(bill)
    end
  end

  def self.down
    remove_column :bills, :bill_html
    remove_column :bills, :govtrack_id
    rename_column :bills, :drumbone_id, :guid
  end
  
  private
  
  def self.govtrack_id(bill)
    downconvert_bill_type(bill.bill_type) + bill.bill_number.to_s + "-" + bill.congress.to_s
  end
  
  def self.downconvert_bill_type(bill_type)
    case bill_type
      when "hr" then "h"
      when "hres" then "hr"
      when "hjres" then "hj"
      when "hcres" then "hc"
      when "s" then "s"
      when "sres" then "sr"
      when "sjres" then "sj"
      when "scres" then "sc"
      else bill_type
    end
  end
end
