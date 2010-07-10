RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "authlogic"
  config.gem "bluecloth"
  config.gem "RedCloth"
  config.gem "linguistics"
  config.gem "feedzirra"
  config.gem "json"
  config.gem "drumbone"
  config.gem "will_paginate"
  config.gem "vestal_versions"
  config.time_zone = 'Mountain Time (US & Canada)'
end
Linguistics::use(:en)
require 'lib/numeric.rb'
require 'lib/string.rb'
