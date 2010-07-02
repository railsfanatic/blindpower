class Suggestion < ActiveRecord::Base
  attr_accessible :kind, :content
  belongs_to :user
end
