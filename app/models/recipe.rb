# http://pastie.org/1189314
class Recipe
  include MongoMapper::Document
  #include Support::Voteable
  
  key :name, String
  key :servings_produced, Float
  
 # key :product_ids, Array
  many :food_entries, :as => 'consumable'
  many :ingredients, :class_name => "Ingredient"#, :in => :product_ids
  many :serving_sizes
end
