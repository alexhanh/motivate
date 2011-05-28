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

Exercise.create!(:name => "Juoksu", :met => 10.0)
Exercise.create!(:name => "Uinti", :met => 8.0)
Exercise.create!(:name => "Istuminen", :met => 1.0)