require 'spec_helper'

describe Post do
  it "should successfully create a new post" do
    user = Factory(:user)
    post = Factory(:post, :user => user)
    post.user.should == user
  end
end
