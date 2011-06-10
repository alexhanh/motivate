# encoding: utf-8
class FoodUnit < ActiveRecord::Base  
  composed_of :quantity, :mapping => [%w(value value), %w(unit unit_id)]
  composed_of :food_data, :class_name => "Food::Data", :mapping => [%w(energy energy), %w(protein protein), %w(carbs carbs), %w(fat fat)]
  
  belongs_to :consumable, :polymorphic => true
  
  validates_numericality_of :protein, :fat, :greater_than_or_equal_to => 0.0, :allow_nil => true
  validates_numericality_of :energy, :carbs, :greater_than_or_equal_to => 0.0
  
  validates_length_of :unit, :in => 1..15
  before_validation :validate_unit
  
  attr_accessor :parent_value, :parent_unit
  before_validation :compute_relation, :if => Proc.new { |fu| fu.parent_unit && fu.parent_value }
  validates_numericality_of :parent_value, :allow_nil => true
  def parent_quantity=(q)
    self.parent_value = q.value
    self.parent_unit = q.unit.id
  end
  
  def validate_unit
    if unit.is_a?(Fixnum) || unit.is_i?
      self.errors.add(:unit, "Yksikön nimi voi koostua vain kirjaimista ja välilyönneistä.") if Units.find(unit).nil?
    else
      self.errors.add(:unit, "Yksikön nimi voi koostua vain kirjaimista ja välilyönneistä.") unless !!(unit =~ /\A[\w ]+\z/)
    end
  end
  
  def compute_relation
    parent_quantity = Quantity.new(parent_value, parent_unit)
    
    if consumable.find_food_unit(parent_quantity.unit)
      self.food_data = consumable.compute_data(parent_quantity)
    else
      self.errors.add(:parent_unit, "Kyseistä yksikköä ei ole olemassa. Kokeile uudelleen.") 
    end
  end
end