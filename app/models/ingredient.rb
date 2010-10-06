class Ingredient
  include MongoMapper::EmbeddedDocument

  key :quantity
  key :unit
  
  one :product
    
  embedded_in :recipe
end
