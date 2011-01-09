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
  
  validates_presence_of :quantity
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0.0
  
  #after_create :update_data
  
  # def unit=(s)
  #   p "WINSKDKSDJDSJDSJDSDJSJDSJDSJ"
  #   p s
  #   if s.is_i?
  #     self.unit = s.to_i
  #   else
  #     self.unit = Units::CUSTOM
  #     self.custom_unit_name = s
  #   end
  # end
  
  def unit_proxy
    return if self.unit.nil?
    return self.custom_unit_name if self.unit.custom?
    return self.unit
  end
  
  def unit_proxy=(s)
    if s.is_i?
      self.unit = s.to_i
    else
      self.unit = Units::CUSTOM
      self.custom_unit_name = s
    end
  end
  
  def update_data
    self.nutrition_data = consumable.compute_data(self.quantity, self.unit, self.custom_unit_name)
  end
end
