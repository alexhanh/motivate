class ExerciseEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  
  composed_of :distance, :class_name => "Quantity", :mapping => [%w(distance_value value), %w(distance_unit unit_id)], :allow_nil => true
  composed_of :energy, :class_name => "Quantity", :mapping => [%w(energy_value value), %w(energy_unit unit_id)], :allow_nil => true
  
  scope :on_date, lambda { |date| where(:exercised_at => Range.new(date.beginning_of_day, date.end_of_day)) }
  
  validates_numericality_of :hours, :greater_than_or_equal_to => 0.0, :allow_nil => true
  validates_numericality_of :minutes, :greater_than_or_equal_to => 0.0, :allow_nil => true
  validates_numericality_of :seconds, :greater_than_or_equal_to => 0.0, :allow_nil => true
  
  validates_numericality_of :energy_value, :allow_nil => true
  validates_presence_of :exercise
  validates_presence_of :exercised_at
  
  before_save :estimate_energy, :if => Proc.new{ |entry| entry.energy_value.nil? }
  before_save :normalize_units
  
  def normalize_units
    self.distance = self.distance.convert(Units.km)
    self.energy = self.energy.convert(Units.kcal)
  end
  
  # Returns the length of the exercise in seconds
  def duration
    (hours || 0)*60*60 + (minutes || 0) * 60 + (seconds || 0)
  end
  
  def userfy(user)
    if energy
      self.energy = self.energy.convert(user.energy_unit)
    else
      self.energy_unit = user.energy_unit.id
    end
    
    if distance
      self.distance = self.distance.convert(user.length_unit)
    else
      self.distance_unit = user.length_unit.id
    end
  end
  
  private
  def estimate_energy
    # Find user's nearest weight entry to exercised_at
    weight_entries = user.tracker_entries.joins(:tracker).where("trackers.name = ?", "weight")
    closest_in_future = weight_entries.where("logged_on >= ?", exercised_at + 1.minute).order(:logged_on).first
    closest_in_past = weight_entries.where("logged_on < ?", exercised_at + 1.minute).order(:logged_on).last

    weight = 0.0
    if closest_in_future || closest_in_past
      # There exists entry on both sides of exercised_at
      if closest_in_future && closest_in_past
        distance_to_future = closest_in_future.logged_on - exercised_at
        distance_to_past = exercised_at - closest_in_past.logged_on
    
        if distance_to_future < distance_to_past
          weight = closest_in_future.quantity.convert(Units.kg).value
        else
          weight = closest_in_past.quantity.convert(Units.kg).value
        end
      # Only on one side
      else
        weight = (closest_in_future || closest_in_past).quantity.convert(Units.kg).value
      end
    end
    
    self.energy = Quantity.new(exercise.met * weight * (duration / 60.0 / 60.0), Units.kcal)
  end
end