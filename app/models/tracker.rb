class Tracker < ActiveRecord::Base  
  DEFAULT_UNITS = {
    "weight" => [Units.kg],
    "height" => [Units.cm, Units.m]
  }
  
  #key :name, String
  #validates_length_of :custom_name, :within => 1..20, :if => :custom?
  #validates_format_of :custom_name, :with => /\A[a-zA-z ]+/, :if => :custom?
  
  # set explicitly in create method to true when adding support for custom trackers!
  validates_inclusion_of :private, :in => [false, true]
  
  # note: do *not* use name 'name' for keys
  #key :custom_unit, String
  validates_length_of :custom_unit, :within => 1..20, :if => :custom?
  #validates_format_of :custom_unit, :with => /\A[_a-zA-z ]+/, :if => :custom?
  
  # when creating a custom and private, set this to custom
  # key :type, String
  # validates_inclusion_of :type, :in => TYPES
  
  has_many :entries, :class_name => "TrackerEntry"
  
  belongs_to :user
  #validates_presence_of :user_id, :if => :private?
  
  ####################
  #
  ####################
  after_save :update_custom_units
  def update_custom_units
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
    !self.custom_unit.nil?
  end
  
  def to_s
    if private?
      self.name
    else
      I18n.t("trackers.#{name}.name")
    end
  end
  
  # Returns the tracker's base unit which is used if there are several default units
  def base_unit
    if custom?
      return Unit.new(self.custom_unit)
    else
      DEFAULT_UNITS[self.name][0]
    end
  end
  
  def units
    if custom?
      return [Unit.new(self.custom_unit)]
    else
      DEFAULT_UNITS[self.name]
    end
  end
end