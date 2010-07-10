config.cache_classes = true
config.whiny_nils = true
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true
config.action_controller.allow_forgery_protection    = false
config.action_mailer.delivery_method = :test

config.gem "koujou" # factories, like cranky
config.gem "faker", :lib => false
config.gem "rspec", :lib => false, :version => ">= 1.3.0" 
config.gem "rspec-rails", :lib => false, :version => ">= 1.3.2" 
config.gem "cucumber", :lib => false, :version => ">= 0.8.3"
config.gem "webrat", :lib => false, :version => ">= 0.7.1"
config.gem "cranky", :lib => false, :version => ">= 0.1.0"
