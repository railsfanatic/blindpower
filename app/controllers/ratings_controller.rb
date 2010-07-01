class RatingController < ApplicationController
  def rate
    @rateable = find_rateable
    
    Rating.destroy_all(["rateable_type = ? AND rateable_id = ? AND user_id = ?", 
      @rateable.type, @rateable.id, current_user.id])
      
    @rateable.add_rating Rating.new(:rating => params[:rating], 
      :user_id => current_user.id)
  end
  
  private
  
  def find_rateable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
