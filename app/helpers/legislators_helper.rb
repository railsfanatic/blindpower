module LegislatorsHelper
  def links_to_legislators(legislators)
    links = []
    legislators.each do |legislator|
      links << link_to(legislator.full_title, legislator)
    end
    links.join(", ")
  end
end
