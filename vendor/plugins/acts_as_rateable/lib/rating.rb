class Rating < ActiveRecord::Base
  belongs_to :rateable, :polymorphic => true
  
  # NOTE: Comments belong to a user
  belongs_to :user
  
  after_save :update_rateable
  after_destroy :update_rateable
  
  def update_rateable
    if rateable.respond_to?("average_rating")
      rateable.update_attribute("average_rating", rateable.rating)
    end
  end
  
  # Helper class method to lookup all ratings assigned
  # to all rateable types for a given user.
  def self.find_ratings_by_user(user)
    find(:all,
      :conditions => ["user_id = ?", user.id],
      :order => "created_at DESC"
    )
  end
end