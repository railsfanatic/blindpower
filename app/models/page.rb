class Page < ActiveRecord::Base
  versioned
  attr_accessible :title, :permalink, :content
end
