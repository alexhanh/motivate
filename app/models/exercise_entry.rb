# encoding: utf-8

class ExerciseEntry < ActiveRecord::Base
  include Support::HasDuration
  
  belongs_to :user
  belongs_to :exercise
  
  # AR expects dates and times to be in UTC when dealing with queries.
  scope :on_date, lambda { |date| where(:exercised_at => date.beginning_of_day.utc..date.end_of_day.utc) }
    
  validates_numericality_of :energy, :allow_nil => true
  validates_numericality_of :distance, :allow_nil => true
  validates_presence_of :exercise
  validates_presence_of :exercised_at
  
  before_save :estimate_energy

  def distance_q
    distance.km
  end
  
  def energy_q
    energy.kcal
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

    if energy.nil?
      now = Time.zone.now
      weight = user.weight_at(now)
      height = user.height_at(now)
      weight ||= user.male? ? 80.kg : 70.kg
      height ||= user.male? ? 168.cm : 157.cm
    
      self.energy = FoodScience.personalized_met(exercise.met, weight, height, user.age, user.gender) * weight.value * (duration / 60.0 / 60.0)
      self.estimated = true
    else
      self.estimated = false
      p self
    end
  end
end