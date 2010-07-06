require 'spec_helper'

describe User do
  it "should succeed creating a valid user with a full name" do
    user = User.koujou_create(:first_name => "John", :last_name => "Doe")
    user.full_name.should == "John Doe"
  end
  
  it "should fail creating an invalid user" do
    user = User.new
    user.should be_invalid
  end
end
