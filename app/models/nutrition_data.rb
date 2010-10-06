class NutritionData
  include MongoMapper::EmbeddedDocument
  
  key :energy, Float
  key :carbs, Float
  key :protein, Float
  key :fat, Float
 
  #embedded_in :serving_size
  
  def scale(f)
    self.energy *= f
    self.carbs *= f
    self.protein *= f
    self.fat *= f
    
    return self
  end
end
