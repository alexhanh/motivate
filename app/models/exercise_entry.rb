class ExerciseEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  
  # AR expects dates and times to be in UTC when dealing with queries.
  scope :on_date, lambda { |date| where(:exercised_at => date.beginning_of_day.utc..date.end_of_day.utc) }
  
  validates_numericality_of :hours, :greater_than_or_equal_to => 0.0, :allow_nil => true
  validates_numericality_of :minutes, :greater_than_or_equal_to => 0.0, :allow_nil => true
  validates_numericality_of :seconds, :greater_than_or_equal_to => 0.0, :allow_nil => true
  
  validates_numericality_of :energy, :allow_nil => true
  validates_numericality_of :distance, :allow_nil => true
  validates_presence_of :exercise
  validates_presence_of :exercised_at
  
  before_save :estimate_energy, :if => Proc.new{ |entry| entry.energy.nil? }
  
  # Returns the length of the exercise in seconds
  def duration
    (hours || 0)*60*60 + (minutes || 0) * 60 + (seconds || 0)
  end
  
  def distance_q
    Quantity.new(distance, Units.km)
  end
  
  private
  def estimate_energy
    # Find user's nearest weight entry to exercised_at
    # weight_entries = user.tracker_entries.joins(:tracker).where("trackers.name = ?", "weight")
    # closest_in_future = weight_entries.where("logged_on >= ?", (exercised_at + 1.minute).utc).order(:logged_on).first
    # closest_in_past = weight_entries.where("logged_on < ?", (exercised_at + 1.minute).utc).order(:logged_on).last
    # 
    # weight = 0.0
    # if closest_in_future || closest_in_past
    #   # There exists entry on both sides of exercised_at
    #   if closest_in_future && closest_in_past
    #     distance_to_future = closest_in_future.logged_on - exercised_at
    #     distance_to_past = exercised_at - closest_in_past.logged_on
    # 
    #     if distance_to_future < distance_to_past
    #       weight = closest_in_future.quantity.convert(Units.kg).value
    #     else
    #       weight = closest_in_past.quantity.convert(Units.kg).value
    #     end
    #   # Only on one side
    #   else
    #     weight = (closest_in_future || closest_in_past).quantity.convert(Units.kg).value
    #   end
    # end
    # 
    # self.energy = exercise.met * weight * (duration / 60.0 / 60.0)
    now = Time.zone.now
    weight = user.weight_at(now)
    height = user.height_at(now)
    weight ||= user.male? ? 80.kg : 70.kg
    height ||= user.male? ? 168.cm : 157.cm
    
    self.energy = FoodScience.personalized_met(exercise.met, weight, height, user.age, user.gender) * weight.value * (duration / 60.0 / 60.0)
  end
end