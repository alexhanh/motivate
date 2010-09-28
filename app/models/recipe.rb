class Recipe
  include MongoMapper::Document
  
  key :name, String
  key :product_ids, Array

  many :ingredients, :class_name => "Product", :in => :product_ids
end
