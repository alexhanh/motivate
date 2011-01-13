# http://pastie.org/1189314
class Recipe
  include MongoMapper::Document
  include Support::Consumable
  
  #include Support::Voteable
  
  key :name, String
  #key :servings_produced, Float
  
  #key :product_ids, Array
  many :ingredients, :dependent => :destroy, :class_name => "Ingredient"
  accepts_nested_attributes_for :ingredients, :allow_destroy => true
  
  validate :check_roots
  
  before_save :update_data
  
  key :user_id
  belongs_to :user

  def update_data
    sum = NutritionStats.new
    ingredients.each {|i| sum.add(i.compute_data)}
    #TODO: concidering moving this to serving_size.set_data(4, Units::DECILITER, data)
    s = serving_sizes[0]
    factor = 1.0/(Units::to_base(s.quantity, s.unit))#*servings_produced)
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
