source 'http://rubygems.org' 

gem 'rails', '3.0.3' 

# HTML Parsing
gem "nokogiri"

gem "mongo", "1.1" 
gem "mongo_mapper", :branch => "rails3", :git => "git://github.com/jnunemaker/mongomapper"
gem "bson_ext", "1.1"
gem "bson", "1.1"

# authentication
gem "devise", "1.1.3" 
gem 'devise-mongo_mapper', :git => 'git://github.com/collectiveidea/devise-mongo_mapper'
#todo: concider changing to https://github.com/kristianmandrup/mm-devise (seems to work with devise 1.1.5)
#      or https://github.com/kristianmandrup/cream-app-mongo_mapper

# authorization
gem 'cancan'

# views
gem "haml"
gem "will_paginate", "3.0.pre2"
gem "compass"

gem "responders", "0.6.2"
gem "unicode"
gem "nifty-generators"

# queue
gem 'resque'

group :production do 
  gem "heroku", "1.10.5" 
end 
group :development do 
  gem "hpricot", "0.8.2" # Only required for 'rails g devise:views' 
  gem "ruby_parser", "2.0.5" # Only required for 'rails g devise:views' 
  gem "haml-rails" # Template generator for HAML 
  gem "jquery-rails" # Template generator for jQuery 
  gem 'rails3-generators' # Template generator for Mongo Mapper 
end 
group :test do 
  gem "simplecov", "0.3.6" 
  gem "rspec", '>= 2.0.0'
  gem "autotest" 
  gem "webrat"
  gem 'factory_girl_rails'
  gem "machinist", "1.0.6" 
  gem "machinist_mongo", :require => 'machinist/mongo_mapper' 
  gem "remarkable"
  gem "remarkable_mongo" 
  gem "faker" 
  # For cucumber-rails 
  gem 'database_cleaner' 
  gem 'cucumber' 
  gem 'spork' 
  gem 'launchy'    # So you can do Then show me the page 
end 
group :development, :test do 
  gem "mocha" 
  gem "rspec-rails", '>= 2.0.0'
  gem 'cucumber-rails', '0.3.2' 
end 
group :console do 
  gem "wirble" 
  gem "hirb" 
end 
