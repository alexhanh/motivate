# http://pastie.org/1189314
class Recipe
  include MongoMapper::Document
  include Support::Consumable
  #include Support::Voteable
  
  key :name, String
  key :servings_produced, Float
  
 # key :product_ids, Array
  many :food_entries, :as => 'consumable'
  many :ingredients, :class_name => "Ingredient"
  many :serving_sizes
  
  validate :check_roots
  
  # after create call update data
  
  def update_data
    
  end
  
  #/////////////////////////
  # Validations
  #/////////////////////////
  
  def check_roots
    count = 0
    self.serving_sizes.each do |s|
      count += 1 if s.root?
    end
    
    if count > 1
      self.errors.add(:serving_sizes, "Recipe can have only one root serving size.")
    end
  end
end
