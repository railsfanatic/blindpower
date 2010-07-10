require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
  require 'spec/autorun'
  require 'spec/rails'
  require 'cranky'
  require 'factories/factories'
  require 'webrat'
  
  # Uncomment the next line to use webrat's matchers
  require 'webrat/integrations/rspec-rails'
  
  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}
  
  Spec::Runner.configure do |config|
    config.use_transactional_fixtures = true
    config.use_instantiated_fixtures  = false
    config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
  end
  
  include Webrat::Methods
  
  Webrat.configure do |config|
    config.mode = :rails
  end
  
  module Spec
    module Rails
      module Matchers
        class BeValid  #:nodoc:

          def matches?(model)
            @model = model
            @model.valid?
          end

          def failure_message
            "#{@model.class} expected to be valid but had errors:\n  #{@model.errors.full_messages.join("\n  ")}"
          end

          def negative_failure_message
            "#{@model.class} expected to have errors, but it did not"
          end

          def description
            "be valid"
          end

        end

        def be_valid
          BeValid.new
        end
      end
    end
  end
  
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

