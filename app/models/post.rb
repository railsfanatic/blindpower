class Post < ActiveRecord::Base
  attr_accessible :user_id, :title, :body, :tag_ids, :new_tag_names
  belongs_to :user
  belongs_to :deleted_by_user, :class_name => "User", :foreign_key => "deleted_by"
  has_and_belongs_to_many :tags
  has_many :comments, :as => :commentable, :dependent => :delete_all
  acts_as_list
  attr_accessor :new_tag_names
  
  validates_presence_of :user_id, :title, :body
  
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
end
