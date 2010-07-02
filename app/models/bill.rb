class Bill < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 20
  has_many :comments, :as => :commentable, :dependent => :delete_all
  belongs_to :sponsor, :class_name => "Legislator"
  has_and_belongs_to_many :cosponsors, :order => :state, :join_table => "bills_cosponsors", :class_name => "Legislator"
  before_validation_on_create :set_drumbone_id
  before_save :update_counts
  after_create :update_me
  
  acts_as_rateable
  
  HUMANIZED_ATTRIBUTES = {
    :drumbone_id => "Bill number"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  validates_presence_of :bill_number, :bill_type, :congress
  
  validates_uniqueness_of :drumbone_id, :on => :create, :message => "is already in the database"
  
  def validate
    if errors.empty?
      begin
        Drumbone::Bill.find :bill_id => self.drumbone_id
      rescue
        errors.add("The requested bill", "does not exist")
      end
    end
  end
  
  def to_param
    "#{id}-#{govtrack_id}"
  end
  
  def full_number
    case bill_type
      when 'h' then 'H.R.'
      when 'hr' then 'H.Res.'
      when 'hj' then 'H.J.Res.'
      when 'hc' then 'H.C.Res.'
      when 's' then 'S.'
      when 'sr' then 'S.Res.'
      when 'sj' then 'S.J.Res.'
      when 'sc' then 'S.C.Res.'
		end + ' ' + bill_number.to_s
  end
  
  def title
    official_title
  end
  
  def status
    state
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
  
  def find_visually_impaired
    r = []
    paragraphs.each { |p| r << p if p =~ /visually\simpaired/i }
    r
  end
  
  def update_counts
    self.cosponsors_count = self.cosponsors.count
    self.text_word_count = self.bill_html.to_s.word_count
    self.summary_word_count = self.summary.to_s.word_count
    self.blind_count = self.find_blind.count
    self.deafblind_count = self.find_deafblind.count
    #self.visually_impaired_count = self.find_visually_impaired.count
    
    # save some space for untracked (deleted) bills
    self.bill_html = "" if self.deleted_at
  end
  
  def set_drumbone_id
    self.drumbone_id = make_drumbone_id(self)
  end
  
  def self.create_from_feed
    feed_url = "http://www.govtrack.us/congress/billsearch_api.xpd?q=blind"
    feed = Feedzirra::Feed.fetch_raw(feed_url)
    results = Feedzirra::Parser::Govtrack.parse(feed).search_results
    results.each do |result|
      bill = Bill.find_by_govtrack_id(make_govtrack_id(result))
      unless bill
        bill = create(
          :govtrack_id  => make_govtrack_id(result),
          :drumbone_id  => make_drumbone_id(result),
          :congress     => result.congress,
          :bill_type    => result.bill_type,
          :bill_number  => result.bill_number,
          :dirty        => true
        )
      end
    end
  end
  
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
  
  def make_drumbone_id(result)
    p = convert_bill_type(result.bill_type) + result.bill_number.to_s + "-" + result.congress.to_s
    logger.info p
    p
  end
  
  def update_me
    self.drumbone_id ||= make_drumbone_id(self)
    drumbone = Drumbone::Bill.find :bill_id => self.drumbone_id
    if drumbone && (self.dirty? ||
          !self.text_updated_on ||
          self.text_updated_on < Date.parse(drumbone.last_action.acted_at) ||
          self.last_action_on != Date.parse(drumbone.last_action.acted_at)
      )
      self.short_title = drumbone.short_title
      self.official_title = drumbone.official_title
      self.last_action_text = drumbone.last_action.text
      self.last_action_on = drumbone.last_action.acted_at
      self.summary = drumbone.summary
      self.state = drumbone.state
      
      s = Legislator.find_by_bioguide_id(drumbone.sponsor.bioguide_id)
      if s
        self.sponsor_id = s.id
      else
        self.create_sponsor(
          :bioguide_id => drumbone.sponsor.bioguide_id,
          :title => drumbone.sponsor.title,
          :first_name => drumbone.sponsor.first_name,
          :last_name => drumbone.sponsor.last_name,
          :name_suffix => drumbone.sponsor.name_suffix,
          :nickname => drumbone.sponsor.nickname,
          :district => drumbone.sponsor.district,
          :state => drumbone.sponsor.state,
          :party => drumbone.sponsor.party,
          :govtrack_id => drumbone.sponsor.govtrack_id
        )
      end
      if drumbone.cosponsors
        self.cosponsors = []
        drumbone.cosponsors.each do |cs|
          self.cosponsors << Legislator.find_or_create_by_bioguide_id(
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
      if !self.text_updated_on || self.text_updated_on < Date.parse(drumbone.last_action.acted_at)
        bill_object = HTTParty.get("http://www.govtrack.us/data/us/bills.text/#{self.congress.to_s}/#{self.bill_type}/#{self.bill_type + self.bill_number.to_s}.html")
        self.bill_html = bill_object.response.body
        self.text_updated_on = Date.today
        logger.info "Updated Bill Text for #{self.drumbone_id}"
      end
      self.dirty = false
      self.save
      true
    else
      false
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
  
  def convert_bill_type(bill_type)
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
