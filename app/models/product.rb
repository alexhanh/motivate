class Product
  include MongoMapper::Document
  
  key :name
  
  many :recipes, :foreign_key => :product_ids
end
