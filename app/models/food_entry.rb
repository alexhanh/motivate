class FoodEntry < ActiveRecord::Base
  belongs_to :user
  
  belongs_to :consumable, :polymorphic => true
  
  composed_of :quantity, :mapping => [%w(value value), %w(unit unit_id)]
  
  scope :on_date, lambda { |date| where(:eaten_at => Range.new(date.beginning_of_day, date.end_of_day)) }
  
  # TODO: Make sure created_at has an index on it!
  # Date should be a Date object, can use Date.civil(2011, 04, 20) or similar
end