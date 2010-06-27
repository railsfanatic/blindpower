class Post < ActiveRecord::Base
  attr_accessible :user_id, :title, :body, :tag_ids
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :comments
  acts_as_list
  
  before_create :check_for_spam
  
  def self.approved
    all(:conditions => { :approved => true }, :order => "created_at DESC")
  end
  
  def self.recent(limit, conditions = nil)
    all(:limit => limit, :conditions => conditions, :order => "created_at DESC")
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
