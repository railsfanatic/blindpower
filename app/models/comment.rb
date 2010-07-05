class Comment < ActiveRecord::Base
  attr_accessible :content
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  validates_presence_of :user_id, :content
  acts_as_list :scope => :commentable
  
  named_scope :recent, :limit => 20, :order => "created_at DESC"
end
