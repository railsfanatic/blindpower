require 'spec_helper'

describe User do
  it "should create a user with a full name" do
    user = Factory(:user, :first_name => "John", :last_name => "Doe")
    user.full_name.should == "John Doe"
  end
end
