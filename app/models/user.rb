class User < ActiveRecord::Base
  acts_as_authentic
  attr_accessible :username, :email, :password, :password_confirmation, :first_name, :last_name, :country_id, :state_id, :address, :city, :zip_code, :phone, :birthdate, :intro, :time_zone
  belongs_to :country
  belongs_to :state
  has_many :posts
  has_many :comments
  has_many :suggestions
  
  def full_name
    first_name + " " + last_name
  end
end
