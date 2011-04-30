class Exercise < ActiveRecord::Base
  has_many :exercise_entries
  
  validates_presence_of :name
end