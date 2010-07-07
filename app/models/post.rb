class Post < ActiveRecord::Base
  attr_accessible :user_id, :title, :body, :tag_ids, :new_tag_names
  belongs_to :user
  belongs_to :deleted_by_user, :class_name => "User", :foreign_key => "deleted_by"
  has_and_belongs_to_many :tags
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :suggestions
  acts_as_list
  attr_accessor :new_tag_names
  
  validates_presence_of :user_id, :title, :body
  
  after_save :create_tags
  
  named_scope :recent, :limit => 20, :order => "created_at DESC"
  named_scope :published, :joins => :user, :conditions => { :users => {:author => true} }
  named_scope :unpublished, :joins => :user, :conditions => { :users => {:author => false} }
  
  def title_with_date
    title + " " + created_at.to_s(:short)
  end
  
  def create_tags
    unless new_tag_names.nil?
      new_tag_names.split(",").each do |name|
        name.strip!
        tags.create(:name => name) unless name.blank?
      end
    end
  end
  
  after_destroy do
    Tag.delete_all("id NOT IN (SELECT tag_id FROM posts_tags)")
  end
end



