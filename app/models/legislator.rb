class Legislator < ActiveRecord::Base
  has_many :sponsored_bills, :class_name => "Bill", :foreign_key => "sponsor_id"
  has_and_belongs_to_many :cosponsored_bills, :class_name => "Bill", :join_table => "bills_cosponsors", :association_foreign_key => "bill_id"
end
