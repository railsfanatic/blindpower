require 'spec_helper'

describe "Blog" do
  context "anonymous user" do
    it "should show a list of only published posts" do
      bob_user = Factory(:user, :username => "bob", :password => "secret", :author => false)
      tom_user = Factory(:user, :username => "tom", :password => "secret", :author => true)
      Factory(:post, :user => bob_user, :title => "visible post")
      visit posts_url
      assert_not_contain "Unpublished"
      assert_not_contain "Deleted"
    end
  end
end
