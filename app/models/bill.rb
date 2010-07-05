class Bill < ActiveRecord::Base
  # will_paginate
  cattr_reader :per_page
  @@per_page = 20
  
  # associations
  has_many :comments, :as => :commentable, :dependent => :delete_all
  belongs_to :sponsor, :class_name => "Legislator"
  has_and_belongs_to_many :cosponsors, :order => :state, :join_table => "bills_cosponsors", :class_name => "Legislator"
  
  # callbacks
  before_validation_on_create :set_ids
  before_save :update_bill
  
  # rateable
  acts_as_rateable
  
  # validations
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
    "#{id}-#{drumbone_id}"
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
  
  def paragraphs
    @paragraphs ||= find_paragraphs
  end
  
  def find_paragraphs
    r = []
    bill_html.to_s.scan(/<p>(.*?)<\/p>/).each { |s| r << s[0] }
    r
  end
  
  def find_pattern(pattern)
    r = []
    paragraphs.each { |p| r << p if p =~ /#{pattern}/i }
    r
  end
  
  def find_blind
    find_pattern("\sblind")
  end
  
  def find_deafblind
    find_pattern("deaf-blind")
  end
  
  def find_visually_impaired
    find_pattern("visually\simpaired")
  end
  
  def set_ids
    drumbone_type = case bill_type
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
    
    self.drumbone_id = "#{drumbone_type}#{bill_number}-#{congress}"
    self.govtrack_id = "#{bill_type}#{congress}-#{bill_number}"
  end
  
  def self.create_from_feed
    feed_url = "http://www.govtrack.us/congress/billsearch_api.xpd?q=blind"
    feed = Feedzirra::Feed.fetch_raw(feed_url)
    results = Feedzirra::Parser::Govtrack.parse(feed).search_results
    results.each do |result|
      bill = new(
        :congress => result.congress,
        :bill_type => result.bill_type,
        :bill_number => result.bill_number
      )
      create bill if bill.valid?
    end
  end
  
  def update_bill
    if self.deleted_at.blank?
      drumbone = Drumbone::Bill.find :bill_id => self.drumbone_id
      if drumbone
        self.short_title = drumbone.short_title
        self.official_title = drumbone.official_title
        self.last_action_text = drumbone.last_action.text
        self.last_action_on = drumbone.last_action.acted_at
        self.summary = drumbone.summary
        self.state = drumbone.state
      
        sponsor = Legislator.find_by_bioguide_id(drumbone.sponsor.bioguide_id)
        if sponsor
          self.sponsor_id = sponsor.id
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
          drumbone.cosponsors.each do |cosponsor|
            self.cosponsors << Legislator.find_or_create_by_bioguide_id(
              cosponsor.bioguide_id,
              :title => cosponsor.title,
              :first_name => cosponsor.first_name,
              :last_name => cosponsor.last_name,
              :name_suffix => cosponsor.name_suffix,
              :nickname => cosponsor.nickname,
              :district => cosponsor.district,
              :state => cosponsor.state,
              :party => cosponsor.party,
              :govtrack_id => cosponsor.govtrack_id
            )
          end
        end
      
        if self.bill_html.blank? || self.text_updated_on.blank? || self.text_updated_on < Date.parse(drumbone.last_action.acted_at)
          bill_object = HTTParty.get("http://www.govtrack.us/data/us/bills.text/#{self.congress.to_s}/#{self.bill_type}/#{self.bill_type + self.bill_number.to_s}.html")
          self.bill_html = bill_object.response.body
          self.text_updated_on = Date.today
          logger.info "Updated Bill Text for #{self.drumbone_id}"
        end
      
        self.cosponsors_count = self.cosponsors.count
        self.text_word_count = self.bill_html.to_s.word_count
        self.summary_word_count = self.summary.to_s.word_count
        self.blind_count = self.find_blind.count
        self.deafblind_count = self.find_deafblind.count
        self.visually_impaired_count = self.find_visually_impaired.count
        true
      else
        false
      end
    else
      self.bill_html = nil
      self.cosponsors = []
      self.sponsor = nil
    end
  end
  
end
