class Post < ActiveRecord::Base
  attr_accessible :user_id, :title, :body
  belongs_to :user
end
