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
  
  belongs_to :consumable, :polymorphic => true
  
  #after_create :update_data
  
  def update_data
    self.nutrition_data = consumable.compute_data(quantity, unit, custom_unit_name)
  end
end
