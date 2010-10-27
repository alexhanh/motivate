class NutritionData
  include MongoMapper::EmbeddedDocument
  
  key :energy, Float
  key :carbs, Float
  key :protein, Float
  key :fat, Float
 
  #embedded_in :serving_size
  validates_presence_of :energy, :carbs, :protein, :fat
  validates_numericality_of :energy, :carbs, :protein, :fat, :greater_than_or_equal_to => 0.0
  
  def scale(f)
    # bad idea, because this is slow
    # see http://bit.ly/969w1z
    NutritionData.new(
      :energy => energy*f,
      :carbs => carbs*f,
      :protein => protein*f,
      :fat => fat*f
    )
  end
end
