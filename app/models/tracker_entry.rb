class TrackerEntry < ActiveRecord::Base
  #composed_of :unit, :mapping => [%w(unit_id id)]
  composed_of :quantity, :mapping => [%w(value value), %w(unit unit_id)]
  
  belongs_to :tracker
  validates_presence_of :tracker_id
  
  belongs_to :user
  validates_presence_of :user_id
  
  validates_numericality_of :value, :greater_than_or_equal_to => 0.0
  
  #key :unit, Integer
  #validates_numericality_of :unit, :only_integer => true # todo: should be in context of metric's unit type
  
  validates_presence_of :logged_on # todo: should also be time before Date.now
end