source 'http://rubygems.org' 

# gem 'rails', '3.1.0.rc4' 
gem 'rails', '3.0.7'

# HTML Parsing
gem "nokogiri"

# Database/PostgreSQL
gem 'pg'
gem 'ancestry'
gem 'pg_search'

# Authentication
gem "devise"

# Authorization
gem 'cancan'

# Views
gem "haml"
gem "will_paginate", "3.0.pre2"
gem "compass"
gem 'rails3-jquery-autocomplete'

# Queue
gem 'resque'

# Uncategorized
gem 'httparty'
gem 'community'

# Have to explicitly set until 0.9.x is stable enough to use
# gem 'rake', '0.8.7'

group :production do 
#  gem "heroku", "1.10.5" 
end 
group :development do
  gem "rails-erd"
  gem "hpricot" # Only required for 'rails g devise:views' 
  gem "ruby_parser" # Only required for 'rails g devise:views' 
  gem "haml-rails" # Template generator for HAML 
  gem "jquery-rails" # Template generator for jQuery 
  gem 'rails3-generators' # Template generator for Mongo Mapper 
end 
group :test do 
#  gem "simplecov", "0.3.6" 
  gem "rspec"
#  gem "autotest" 
#  gem "webrat"
#  gem 'factory_girl_rails'
#  gem "machinist", "1.0.6" 
#  gem "remarkable"
#  gem "faker" 
  # For cucumber-rails 
#  gem 'database_cleaner' 
#  gem 'cucumber' 
#  gem 'spork' 
#  gem 'launchy'    # So you can do Then show me the page 
end 
group :development, :test do 
#  gem "mocha" 
  gem "rspec-rails"
#  gem 'cucumber-rails', '0.3.2' 
end 
group :console do 
  # gem "wirble" 
  # gem "hirb" 
end 
