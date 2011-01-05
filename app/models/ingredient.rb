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
  
  #/////////////////////////
  # Virtual attributes
  #/////////////////////////
  
  def serving_size=(s)
    serving_size = self.product.serving_sizes.find(s)
    self.unit = serving_size.unit
    self.custom_unit_name = serving_size.unit_name if serving_size.custom?
  end
  
  def serving_size
    
  end
end
