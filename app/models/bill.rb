class Bill < ActiveRecord::Base
  def self.update_from_feed(feed_url = nil)
    feed_url ||= "http://www.govtrack.us/congress/billsearch_api.xpd?q=blind"
    feed = Feedzirra::Feed.fetch_raw(feed_url)
    results = Feedzirra::Parser::Govtrack.parse(feed).search_results
    results.each do |result|
      bill = Bill.find(:first, :conditions => { :guid => guid(result) })
      if bill
        bill.update_attribute(:status, result.status) unless bill.status == result.status
      else
        create!(
          :guid         => guid(result),
          :congress     => result.congress,
          :bill_type    => result.bill_type,
          :bill_number  => result.bill_number,
          :title        => result.title,
          :link         => result.link,
          :status       => result.status
        )
      end # unless
    end # each
  end # self.update_from_feed
  
  def self.guid(result)
    result.bill_type + result.bill_number + "-" + result.congress
  end
end
