class FoodUnit < ActiveRecord::Base
  # has_ancestry
  
  composed_of :quantity, :mapping => [%w(value value), %w(unit unit_id)]
  # composed_of :parent_quantity, :class_name => "Quantity", :mapping => [%w(parent_value value), %w(parent_unit unit_id)], :allow_nil => true
  composed_of :food_data, :class_name => "Food::Data", :mapping => [%w(energy energy), %w(protein protein), %w(carbs carbs), %w(fat fat)]#, :allow_nil => true
  
  belongs_to :consumable, :polymorphic => true
  
  validates_numericality_of :energy, :protein, :carbs, :fat, :greater_than_or_equal_to => 0.0, :allow_nil => true
end