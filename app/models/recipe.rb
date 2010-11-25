# http://pastie.org/1189314
class Recipe
  include MongoMapper::Document
  include Support::Consumable
  #include Support::Voteable
  
  key :name, String
  key :units_produced, Float
  key :unit, Integer
  
 # key :product_ids, Array
  many :ingredients, :class_name => "Ingredient"
  
  validate :check_roots
  validates_presence_of :unit, :units_produced
  
  # after create call update data

  #TODO: test  
  def update_data
    sum = NutritionStats.new
    ingredients.each {|i| sum.add(i.compute_data)}
    #TODO: concidering moving this to serving_size.set_data(4, Units::DECILITER, data)

    factor = 1.0/Units::to_base(units_produced, unit)
    serving_sizes[0].nutrition_data = sum.data.scale(factor)
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
