class BillsController < ApplicationController
  def index
    feed = Feedzirra::Feed.fetch_raw("http://www.govtrack.us/congress/billsearch_api.xpd?q=blind")
    @results = Feedzirra::Parser::Govtrack.parse(feed).search_results
  end
end
