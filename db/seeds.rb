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

User.create!(:email => "alexander.hanhikoski@gmail.com", :username => "alexhanh", :password => "salanopa", :password_confirmation => "salanopa")

Tracker.create!(:private => false, :name => "weight")
Tracker.create!(:private => false, :name => "height")
Tracker.create!(:private => false, :name => "body_fat", :custom_unit => "%")

Exercise.create!(:name => "Juoksu", :met => 10.0)
Exercise.create!(:name => "Uinti", :met => 8.0)
Exercise.create!(:name => "Istuminen", :met => 1.0)