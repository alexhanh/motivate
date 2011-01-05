source 'http://rubygems.org' 
gem 'rails', '3.0.3' 

#MongoDB
gem "mongo", "1.1" 
#gem "bson_ext", "1.0.7" 
gem "bson_ext", "1.1"
gem "bson", "1.1"
gem "devise", "1.1.3" 
gem "mongo_mapper", :branch => "rails3", :git => "git://github.com/jnunemaker/mongomapper"
gem 'devise-mongo_mapper', :git => 'git://github.com/collectiveidea/devise-mongo_mapper' 
#gem 'hunt', :git => 'git://github.com/jnunemaker/hunt.git'
gem 'fast-stemmer', :git => 'git://github.com/romanbsd/fast-stemmer.git'

gem "haml", "3.0.18" 
gem "responders", "0.6.2"
gem "unicode"
gem "nifty-generators"
gem "will_paginate", "3.0.pre2"

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
  gem "rspec", "2.0.0.beta.22" 
  gem "autotest" 
  gem "webrat"
  gem 'factory_girl_rails'
  gem "machinist", "1.0.6" 
  gem "machinist_mongo", :require => 'machinist/mongo_mapper' 
  gem "remarkable", "4.0.0.alpha4" 
  gem "remarkable_mongo" 
  gem "faker" 
  # For cucumber-rails 
  gem 'database_cleaner' 
  gem 'cucumber', "0.9.0" 
  gem 'spork' 
  gem 'launchy'    # So you can do Then show me the page 
end 
group :development, :test do 
  gem "mocha" 
  gem "rspec-rails", "2.0.0.beta.22" 
  gem 'cucumber-rails', '0.3.2' 
end 
group :console do 
  gem "wirble" 
  gem "hirb" 
end 
