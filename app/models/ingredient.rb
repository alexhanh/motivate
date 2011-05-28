class Ingredient < ActiveRecord::Base
  composed_of :quantity, :mapping => [%w(value value), %w(unit unit_id)]
  
  belongs_to :recipe
  validates_presence_of :recipe_id
  
  validates_numericality_of :value, :greater_than_or_equal_to => 0.0
end