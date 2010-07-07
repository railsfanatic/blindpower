class Legislator < ActiveRecord::Base
  has_many :sponsored, :class_name => "Bill", :foreign_key => "sponsor_id", :conditions => { :bills => { :hidden => false } }
  has_and_belongs_to_many :cosponsored, :class_name => "Bill", :join_table => "bills_cosponsors", :association_foreign_key => "bill_id", :conditions => { :bills => { :hidden => false } }
  
  def first_or_nick
    nickname.blank? ? first_name : nickname
  end
  
  def chamber
    case title
    when "Rep" then "U.S. House of Representatives"
    when "Sen" then "U.S. Senate"
    else title
    end
  end
  
  def full_name
    "#{first_or_nick} #{last_name}"
  end
  
  def full_title
    "#{title} #{full_name} (#{party}-#{state})"
  end
  
  def state_name
    state.to_us_state
  end
  
  def party_name
    case party
    when "D" then "Democrat"
    when "R" then "Republican"
    when "I" then "Independent"
    else party
    end
  end
end
