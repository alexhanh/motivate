class Ingredient
  include MongoMapper::EmbeddedDocument

  key :quantity, Float
  key :unit, Integer
  
  # cached values
  key :custom_unit_name, String
  
  key :product_id, ObjectId
  belongs_to :product, :class_name => 'Product'
    
  embedded_in :recipe
   
  validates_presence_of :product, :quantity, :unit
  validates_presence_of :custom_unit_name, :if => lambda { unit.custom? }
  
  def compute_data
    product.compute_data(quantity, unit, custom_unit_name)
  end
end
