class Suggestion < ActiveRecord::Base
  attr_accessible :kind, :content
  belongs_to :user
  
  validates_presence_of :user_id, :kind, :content
end
