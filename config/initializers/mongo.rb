#Alternatively use ../mongo.yml file, see http://bit.ly/9gWJSi

MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
MongoMapper.database = "#gr-#{Rails.env}"

if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect_to_master if forked
   end
end

require 'support/consumable'
