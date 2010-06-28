module Feedzirra
  module Parser
    class Govtrack
      include SAXMachine
      include FeedUtilities
      elements :result, :as => :search_results, :class => GovtrackResult
      
      def self.able_to_parse?(xml) #:nodoc:
        1
        # xml =~ /<search-results/
      end
    end
  end
end
