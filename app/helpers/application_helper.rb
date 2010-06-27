# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pretty_date(date = Time.now)
    date.strftime("%B %d#{", %Y" if date.year != Date.today.year}")
  end
end
