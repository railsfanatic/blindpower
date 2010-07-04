class Post < ActiveRecord::Base
  attr_accessible :user_id, :title, :body, :tag_ids, :new_tag_names
  belongs_to :user
  belongs_to :deleted_by_user, :class_name => "User", :foreign_key => "deleted_by"
  has_and_belongs_to_many :tags
  has_many :comments, :as => :commentable, :dependent => :delete_all
  acts_as_list
  attr_accessor :new_tag_names
  
  validates_presence_of :title, :body
  
  before_create :check_for_spam
  after_save :create_tags
  
  named_scope :recent, :limit => 20, :order => "created_at DESC"
  named_scope :published, :joins => :user, :conditions => { :deleted_at => nil, :users => {:author => true} }
  named_scope :unpublished, :joins => :user, :conditions => { :deleted_at => nil, :users => {:author => false} }
  named_scope :deleted, :conditions => "deleted_at IS NOT NULL"
  
  def create_tags
    unless new_tag_names.nil?
      new_tag_names.split(",").each do |name|
        name.strip!
        tags.create(:name => name) unless name.blank?
      end
    end
  end
  
  def request=(request)
    self.user_ip = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referer = request.env['HTTP_REFERER']
  end
  
  # Akismetor http://svn.railscasts.com/public/plugins/akismetor
  def check_for_spam
    self.approved = !Akismetor.spam?(akismet_attributes)
    true
  end
  
  def akismet_attributes
    {
      :key => "660154d8fe4f",
      :blog => "http://blindpower.org",
      :user_ip => user_ip,
      :user_agent => user_agent,
      :comment_author => user.username,
      :comment_author_email => user.email,
      :comment_author_url => nil,
      :comment_content => body
    }
  end
  
  def mark_as_spam!
    update_attribute(:approved, false)
    Akismetor.submit_spam(akismet_attributes)
  end

  def mark_as_ham!
    update_attribute(:approved, true)
    Akismetor.submit_ham(akismet_attributes)
  end
end
