class NutritionData
  include MongoMapper::EmbeddedDocument
  
  key :energy, Float
  key :carbs, Float
  key :protein, Float
  key :fat, Float
 
  #embedded_in :serving_size
  
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
