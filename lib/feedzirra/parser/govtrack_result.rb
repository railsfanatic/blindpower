module Feedzirra
  module Parser
    class GovtrackResult
      include SAXMachine
      include FeedEntryUtilities
      
      element :congress
      element :bill_type
      element :bill_number
      element :title
      element :link
      element :bill_status
    end
  end
end
