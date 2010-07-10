require 'spec_helper'

describe Bill do
  it "should create and properly retrieve a bill's information given valid type, number, and congress" do
    bill = Bill.create!(:bill_type => 'hr', :bill_number => 1034, :congress => 111)
    bill.govtrack_id.should == "hr111-1034"
    bill.drumbone_id.should == "hres1034-111"
    bill.official_title.should =~ /Braille/
    bill.summary.should =~ /blind children/
    bill.bill_html.should =~ /Louis Braille Bicentennial-Braille Literacy Commemorative Coin Act/
    bill.cosponsors.count.should == 28
  end
  
  it "should clear out bill_html, sponsor, and cosponsors on deletion" do
    bill = Bill.create!(:bill_type => 'hr', :bill_number => 1034, :congress => 111)
    bill.hidden = true
    bill.save
    bill.bill_html.should be_nil
    bill.sponsor.should be_nil
    bill.cosponsors.count.should == 0
  end
  
  it "should restore all original info on hidden = false" do
    bill = Bill.create!(:bill_type => 'hr', :bill_number => 1034, :congress => 111)
    bill.hidden = false
    bill.save
    bill.govtrack_id.should == "hr111-1034"
    bill.drumbone_id.should == "hres1034-111"
    bill.official_title.should =~ /Braille/
    bill.summary.should =~ /blind children/
    bill.bill_html.should =~ /Louis Braille Bicentennial-Braille Literacy Commemorative Coin Act/
    bill.cosponsors.count.should == 28
  end
end
