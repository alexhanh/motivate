# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

############
# Trackers #
############

Tracker.create({ :private => false, :type => "weight" })
Tracker.create({ :private => false, :type => "height" })
Tracker.create({ :private => false, :type => "custom", :custom_name => "body_fat", :custom_unit => "%" })