class ExerciseEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
      
  validates_numericality_of :hours, :greater_than_or_equal_to => 0.0, :allow_nil => true
  validates_numericality_of :minutes, :greater_than_or_equal_to => 0.0, :allow_nil => true
  validates_numericality_of :seconds, :greater_than_or_equal_to => 0.0, :allow_nil => true
  
  validates_numericality_of :energy
  
  validates_presence_of :exercised_at
  
  before_validation :calculate_energy, :if => Proc.new{ |entry| entry.energy.nil? }
  
  # Returns the length of the exercise in seconds
  def duration
    (hours || 0)*60*60 + (minutes || 0) * 60 + (seconds || 0)
  end
  
  private
  def calculate_energy
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
    
    self.energy = exercise.met * weight * (duration / 60.0 / 60.0)
    # self.energy = exercise.met * user.nearest_weight(self.exercised_at) * (duration / 60.0 / 60.0)
  end
end