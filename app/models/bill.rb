class Bill < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 20
  has_many :comments, :as => :commentable, :dependent => :delete_all
  belongs_to :sponsor, :class_name => "Legislator"
  has_and_belongs_to_many :cosponsors, :join_table => "bills_cosponsors", :class_name => "Legislator"
  acts_as_rateable
  
  def bill_title
    short_title.blank? ? official_title : short_title
  end
  
  def full_number
    title.split(":").first
  end
  
  def self.update_from_feed
    feed_url = "http://www.govtrack.us/congress/billsearch_api.xpd?q=blind"
    feed = Feedzirra::Feed.fetch_raw(feed_url)
    results = Feedzirra::Parser::Govtrack.parse(feed).search_results
    results.each do |result|
      bill = Bill.find_by_guid(guid(result), :conditions => "deleted_at IS NULL")
      if bill
        bill.update_attribute(:status, result.status)
      else
        bill = create(
          :guid         => guid(result),
          :congress     => result.congress,
          :bill_type    => convert_bill_type(result.bill_type),
          :bill_number  => result.bill_number,
          :title        => result.title,
          :link         => result.link,
          :status       => result.status
        )
      end
      update_from_drumbone(bill)
    end # each
  end # self.update_from_feed
  
  def self.guid(result)
    convert_bill_type(result.bill_type) + result.bill_number + "-" + result.congress
  end
  
  def self.update_from_drumbone(bill)
    Drumbone.api_key = "6fe08735b92a48b9a20570daeb7138f7"
    db = Drumbone::Bill.find :bill_id => bill.guid
    bill.short_title = db.short_title
    bill.official_title = db.official_title
    bill.last_action_text = db.last_action.text
    bill.last_action_on = db.last_action.acted_at
    bill.summary = db.summary
    bill.save
    
    s = Legislator.find_by_bioguide_id(db.sponsor.bioguide_id)
    if s
      bill.sponsor_id = s.id
    else
      bill.create_sponsor(
        :bioguide_id => db.sponsor.bioguide_id,
        :title => db.sponsor.title,
        :first_name => db.sponsor.first_name,
        :last_name => db.sponsor.last_name,
        :name_suffix => db.sponsor.name_suffix,
        :nickname => db.sponsor.nickname,
        :district => db.sponsor.district,
        :state => db.sponsor.state,
        :party => db.sponsor.party,
        :govtrack_id => db.sponsor.govtrack_id
      )
    end
    if db.cosponsors
      bill.cosponsors = []
      db.cosponsors.each do |cs|
        bill.cosponsors << Legislator.find_or_create_by_bioguide_id(
          cs.bioguide_id,
          :title => cs.title,
          :first_name => cs.first_name,
          :last_name => cs.last_name,
          :name_suffix => cs.name_suffix,
          :nickname => cs.nickname,
          :district => cs.district,
          :state => cs.state,
          :party => cs.party,
          :govtrack_id => cs.govtrack_id
        )
      end
      
      cosponsors_count = bill.cosponsors.length
      bill.save
    end
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
