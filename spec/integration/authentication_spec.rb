require 'spec_helper'

describe "Authentication" do
  context "Login Page" do
    it "should accept a valid username and password" do
      User.koujou_create(:username => "bob", :password => "secret")
      visit login_url
      fill_in "Username", :with => "bob"
      fill_in "Password", :with => "secret"
      click_button "Login"
      assert_contain "Logged in as: bob"
    end
  
    it "should reject a bad username and password" do
      User.koujou_create(:username => "bob", :password => "secret")
      visit login_url
      fill_in "Username", :with => "bob"
      fill_in "Password", :with => "wrong"
      click_button "Login"
      assert_contain "Password combination is not valid"
    end
  
    it "should reject too many failed logins" do
      User.koujou_create(:username => "badguy", :password => "secret")
      visit login_url
      11.times do
        fill_in "Username", :with => "badguy"
        fill_in "Password", :with => "wrong"
        click_button "Login"
      end
      assert_contain "Consecutive failed logins limit exceeded"
    end
  end
end
