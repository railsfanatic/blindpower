class Bill < ActiveRecord::Base
  has_many :comments, :as => :commentable, :dependent => :delete_all
  belongs_to :sponsor, :class_name => "Legislator"
  has_and_belongs_to_many :cosponsors, :join_table => "bills_cosponsors", :class_name => "Legislator"
  
  def self.update_from_feed
    feed_url = "http://www.govtrack.us/congress/billsearch_api.xpd?q=blind"
    feed = Feedzirra::Feed.fetch_raw(feed_url)
    results = Feedzirra::Parser::Govtrack.parse(feed).search_results
    results.each do |result|
      bill = Bill.find(:first, :conditions => { :guid => guid(result) })
      if bill
        bill.update_attribute(:status, result.status) unless bill.status == result.status
      else
        create!(
          :guid         => guid(result),
          :congress     => result.congress,
          :bill_type    => convert_bill_type(result.bill_type),
          :bill_number  => result.bill_number,
          :title        => result.title,
          :link         => result.link,
          :status       => result.status
        )
      end # unless
    end # each
  end # self.update_from_feed
  
  def self.guid(result)
    convert_bill_type(result.bill_type) + result.bill_number + "-" + result.congress
  end
  
  private
  
  def self.convert_bill_type(bill_type)
    case bill_type
      when "h" then "hr"
      when "hr" then "hres"
      when "hj" then "hjres"
      when "hc" then "hcres"
      when "s" then "s"
      when "sr" then "sres"
      when "sj" then "sjres"
      when "sc" then "scres"
      else bill_type
    end
  end
end
