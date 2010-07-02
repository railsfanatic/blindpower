require 'test_helper'

class SuggestionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Suggestion.new.valid?
  end
end
