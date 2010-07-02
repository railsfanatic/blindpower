class Bill < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 20
  has_many :comments, :as => :commentable, :dependent => :delete_all
  belongs_to :sponsor, :class_name => "Legislator"
  has_and_belongs_to_many :cosponsors, :order => :state, :join_table => "bills_cosponsors", :class_name => "Legislator"
  acts_as_rateable
  before_save :update_counts
  include HTTParty
  
  def to_param
    "#{id}-#{govtrack_id}"
  end
  
  def paragraphs
    @paragraphs ||= find_paragraphs
  end
  
  def find_paragraphs
    r = []
    bill_html.to_s.scan(/<p>(.*?)<\/p>/).each { |s| r << s[0] }
    r
  end
  
  def find_blind
    r = []
    paragraphs.each { |p| r << p if p =~ /\sblind/i }
    r
  end
  
  def find_deafblind
    r = []
    paragraphs.each { |p| r << p if p =~ /deaf-blind/i }
    r
  end
  
  def update_counts
    self.cosponsors_count = self.cosponsors.count
    self.text_word_count = self.bill_html.to_s.word_count
    self.summary_word_count = self.summary.to_s.word_count
    self.blind_count = self.find_blind.count
    self.deafblind_count = self.find_deafblind.count
    # save some space for untracked bills
    self.bill_html = "" if self.deleted_at
  end
  
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
      bill = Bill.find_by_govtrack_id(make_govtrack_id(result))
      unless bill && bill.deleted_at # ignore deleted
        if bill
          unless bill.status == result.status
            bill.update_attribute(:status, result.status)
            bill.dirty = true
          end
        else
          bill = create(
            :govtrack_id  => make_govtrack_id(result),
            :drumbone_id  => make_drumbone_id(result),
            :congress     => result.congress,
            :bill_type    => result.bill_type,
            :bill_number  => result.bill_number,
            :title        => result.title,
            :link         => result.link,
            :status       => result.status,
            :dirty        => true
          )
        end
        update_from_drumbone(bill)
        update_bill_text(bill) if bill.dirty?
      end # ignore deleted bills
    end # each
  end # self.update_from_feed
  
  def self.make_govtrack_id(result)
    p = result.bill_type + result.bill_number.to_s + "-" + result.congress.to_s
    logger.info p
    p
  end
  
  def self.make_drumbone_id(result)
    p = convert_bill_type(result.bill_type) + result.bill_number.to_s + "-" + result.congress.to_s
    logger.info p
    p
  end
  
  def self.update_from_drumbone(bill)
    db = Drumbone::Bill.find :bill_id => bill.drumbone_id
    if bill.dirty? || bill.last_action_on.to_formatted_s(:db) != Date.parse(db.last_action.acted_at).to_formatted_s(:db)
      bill.short_title = db.short_title
      bill.official_title = db.official_title
      bill.last_action_text = db.last_action.text
      bill.last_action_on = db.last_action.acted_at
      bill.summary = db.summary
      
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
      end
      
      bill.save
    end
  end
  
  def self.update_bill_text(bill)
    bill_object = get("http://www.govtrack.us/data/us/bills.text/#{bill.congress.to_s}/#{bill.bill_type}/#{bill.bill_type + bill.bill_number.to_s}.html")
    bill.bill_html = bill_object.response.body
    bill.dirty = false
    bill.save
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
