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

user = User.create!(:email => "alexander.hanhikoski@gmail.com", :username => "alexhanh", :password => "salanopa", :password_confirmation => "salanopa", :gender => true, :birthday => 24.years.ago)

weight_tracker = Tracker.create!(:private => false, :name => "weight")
height_tracker = Tracker.create!(:private => false, :name => "height")
step_tracker   = Tracker.create!(:private => false, :name => "steps", :custom_unit => "askelta")
body_fat_tracker = Tracker.create!(:private => false, :name => "body_fat", :custom_unit => "%")

TrackerEntry.create!(:tracker => weight_tracker, :user => user, :logged_on => 1.week.ago, :quantity => Quantity.new(80, Units.kg))
TrackerEntry.create!(:tracker => height_tracker, :user => user, :logged_on => 2.weeks.ago, :quantity => Quantity.new(180, Units.cm))

# https://sites.google.com/site/compendiumofphysicalactivities/
Exercise.create!(:name => "running", :met => 10.0)
Exercise.create!(:name => "swimming", :met => 8.0)
Exercise.create!(:name => "bicycling", :met => 7.5)
Exercise.create!(:name => "badminton", :met => 7.0)
Exercise.create!(:name => "basketball", :met => 6.5)
Exercise.create!(:name => "football", :met => 8.0)
Exercise.create!(:name => "golf", :met => 4.8)
Exercise.create!(:name => "handball", :met => 12.0)
Exercise.create!(:name => "ice_hockey", :met => 8.0)
Exercise.create!(:name => "orienteering", :met => 9.0)
Exercise.create!(:name => "rock_climbing", :met => 7.5)
Exercise.create!(:name => "squash", :met => 7.3)
Exercise.create!(:name => "table_tennis", :met => 4.0)
Exercise.create!(:name => "tennis", :met => 7.3)
Exercise.create!(:name => "volleyball", :met => 6.0)
Exercise.create!(:name => "walking", :met => 4.3)
Exercise.create!(:name => "swimming", :met => 6.0)
Exercise.create!(:name => "water_jogging", :met => 8.0)