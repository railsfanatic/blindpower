require 'spec_helper'

describe Bill do
  it "should create and properly retrieve a bill's information given valid type, number, and congress" do
    bill = Factory(:bill)
    bill.govtrack_id.should == "hr111-1034"
    bill.drumbone_id.should == "hres1034-111"
    bill.official_title.should =~ /Braille/
    bill.summary.should =~ /blind children/
    bill.bill_html.should =~ /Louis Braille Bicentennial-Braille Literacy Commemorative Coin Act/
    bill.cosponsors.count.should == 28
  end
  
  it "should clear out bill_html, sponsor, and cosponsors on deletion" do
    bill = Factory(:bill)
    bill.update_attribute(:deleted_at, Time.now)
    bill.bill_html.should be_nil
    bill.sponsor.should be_nil
    bill.cosponsors.count.should == 0
  end
  
  it "should restore all original info on deleted_at = nil" do
    bill = Factory(:bill)
    bill.update_attribute(:deleted_at, Time.now)
    bill.update_attribute(:deleted_at, nil)
    bill.govtrack_id.should == "hr111-1034"
    bill.drumbone_id.should == "hres1034-111"
    bill.official_title.should =~ /Braille/
    bill.summary.should =~ /blind children/
    bill.bill_html.should =~ /Louis Braille Bicentennial-Braille Literacy Commemorative Coin Act/
    bill.cosponsors.count.should == 28
  end
end
