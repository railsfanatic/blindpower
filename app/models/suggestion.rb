class Suggestion < ActiveRecord::Base
  attr_accessible :kind, :content, :post_id
  belongs_to :user
  belongs_to :post, :include => :user, :conditions => { :users => { :author => true } }
  
  validates_presence_of :user_id, :kind, :content
end
