module Feedzirra
  module Parser
    class GovtrackResult
      include SAXMachine
      include FeedEntryUtilities
      
      element :congress
      element :"bill-type", :as => :bill_type
      element :"bill-number", :as => :bill_number
      element :title
      element :link
      element :"bill-status", :as => :status
    end
  end
end
