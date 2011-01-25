class TrackerEntry
  include MongoMapper::Document

  key :value, Float
  validates_numericality_of :value, :greater_than_or_equal_to => 0.0

  key :unit, Integer
  validates_numericality_of :unit, :only_integer => true # todo: should be in context of metric's unit type

  key :logged_on, Date
  validates_presence_of :logged_on # todo: should also be time before Date.now

  belongs_to :tracker
  key :tracker_id, ObjectId
  validates_presence_of :tracker_id
  
  belongs_to :user
  key :user_id, ObjectId
  validates_presence_of :user_id
  
  ###############
  # Cached data #
  ###############
  key :cached_custom_unit, String
  before_save :cache_info
  
  def cache_info
    self.cached_custom_unit = tracker.custom_unit
  end
  
  def unit_name
    if unit.custom?
      self.cached_custom_unit 
    else
      self.unit.unit_name
    end
  end
end