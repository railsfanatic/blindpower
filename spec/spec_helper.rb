ENV["RAILS_ENV"] = 'test'

require 'rubygems'
require 'spork'


Spork.prefork do
  require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
  require 'spec/autorun'
  require 'spec/rails'
  require 'authlogic/test_case'
  
  # Uncomment the next line to use webrat's matchers
  #require 'webrat/integrations/rspec-rails'

  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}
  
  Spec::Runner.configure do |config|
    # If you're not using ActiveRecord you should remove these
    # lines, delete config/database.yml and disable :active_record
    # in your config/boot.rb
    #config.use_transactional_fixtures = true
    #config.use_instantiated_fixtures  = false
    #config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  end
  
  include Authlogic::TestCase
  include Webrat::Methods
  
  module Spec::Rails::Example
    class IntegrationExampleGroup < ActionController::IntegrationTest

     def initialize(defined_description, options={}, &implementation)
       defined_description.instance_eval do
         def to_s
           self
         end
       end

       super(defined_description)
     end

      Spec::Example::ExampleGroupFactory.register(:integration, self)
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end


Webrat.configure do |config|
  config.mode = :rails
end
