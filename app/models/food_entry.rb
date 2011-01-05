class FoodEntry
  include MongoMapper::Document
 
  key :quantity, Float
  key :unit, Integer
  
  # cached values
  # TODO: fire up job to replace custom_unit_name with updated value and calls update_data
  key :custom_unit_name, String
  one :nutrition_data
 
  key :user_id, ObjectId
  belongs_to :user
  
  key :consumable_id, ObjectId
  key :consumable_type, String
  belongs_to :consumable, :polymorphic => true
  
  #after_create :update_data
  
  def unit_name
    ""
  end
  
  def unit_name=(s)
    if s.is_i?
      self.unit = s
    else
      self.unit = Units::CUSTOM
      self.custom_unit_name = s
    end
  end
  
  def update_data
    self.nutrition_data = consumable.compute_data(quantity, unit, custom_unit_name)
    p self.nutrition_data
  end
end
