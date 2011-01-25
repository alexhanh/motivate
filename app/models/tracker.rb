class Tracker
  include MongoMapper::Document
  
  TYPES = %w[custom weight height]
  DEFAULT_UNITS = {
    "custom" => [Units::CUSTOM], # hmm?
    "weight" => [Units::KILOGRAM],
    "height" => [Units::CENTIMETER, Units::METER]
  }
  
  key :custom_name, String
  validates_length_of :custom_name, :within => 1..20, :if => :custom?
  #validates_format_of :custom_name, :with => /\A[a-zA-z ]+/, :if => :custom?
  
  # set explicitly in create method to true when adding support for custom trackers!
  key :private, Boolean
  validates_inclusion_of :private, :in => [false, true]
  
  # note: do *not* use name 'name' for keys
  key :custom_unit, String
  validates_length_of :custom_unit, :within => 1..20, :if => :custom?
  #validates_format_of :custom_unit, :with => /\A[a-zA-z ]+/, :if => :custom?
  
  # when creating a custom and private, set this to custom
  key :type, String
  validates_inclusion_of :type, :in => TYPES
  
  many :entries, :class_name => "TrackerEntry"
  
  belongs_to :user
  key :user_id, ObjectId
  validates_presence_of :user_id, :if => :private?
  
  ####################
  #
  ####################
  after_save :update_cached_info_in_entries
  def update_cached_info_in_entries
    # about update_attributes! http://groups.google.com/group/mongomapper/browse_thread/thread/d77c5af3ddfd7fe4
    entries.each { |e| e.update_attributes!({ :cached_custom_unit => custom_unit }) }
  end
  
  def private?
    self.private
  end
  
  def public?
    !self.private
  end
  
  def custom?
    type == "custom"
  end
  
  def name
    if private?
      self.custom_name
    elsif custom?
      I18n.t("tracker.#{custom_name}.name")
    else
      I18n.t("tracker.#{type}.name")
    end
  end
  
  def units
    # handle custom
    DEFAULT_UNITS[type]
  end
end