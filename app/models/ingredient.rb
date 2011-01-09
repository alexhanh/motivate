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
  
  # def serving_size=(s)
  #   serving_size = self.product.serving_sizes.find(s)
  #   self.unit = serving_size.unit
  #   self.custom_unit_name = serving_size.unit_name if serving_size.custom?
  # end
  # 
  # def serving_size
  #   
  # end
  
  def unit_proxy
    return if unit.nil?
    return custom_unit_name if unit.custom?
    return unit
  end
  
  def unit_proxy=(s)
    if s.is_i?
      self.unit = s.to_i
    else
      self.unit = Units::CUSTOM
      self.custom_unit_name = s
    end
    
    s = product.find_serving_size(unit, custom_unit_name)
    # TODO: Add an error here!
    return if s.nil?
  end
  
  #/////
  
  def unit_name
    return if self.unit.nil?
    return self.custom_unit_name if self.unit.custom?

    Units::find_string_by_code(self.unit)
  end
end
