class Legislator < ActiveRecord::Base
  has_many :sponsored, :class_name => "Bill", :foreign_key => "sponsor_id"
  has_and_belongs_to_many :cosponsored, :class_name => "Bill", :join_table => "bills_cosponsors", :association_foreign_key => "bill_id"
  
  def first_or_nick
    nickname.blank? ? first_name : nickname
  end
  
  def full_name
    "#{title} #{first_or_nick} #{last_name} (#{party}-#{state})"
  end
  
  def state_name
    state.to_us_state
  end
end
