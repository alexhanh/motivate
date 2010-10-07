class Product
  include MongoMapper::Document
  
  key :name
  
  key :user_id
  belongs_to :user

  many :recipes, :foreign_key => :product_ids
  
  many :food_entries, :as => 'consumable' 
  many :serving_sizes, :class_name => 'ServingSize'

  validates_presence_of :name

  validates_associated :serving_sizes
  validate :check_serving_size_count
  validate :check_weight_volume
    
  # Find all recipes with ingredient
  # Recipe.find("ingredients" => { :$elemMatch => {"_id" => "salt"} })
  
  #/////////////////////////
  # Validations
  #/////////////////////////
  private
  
  def check_serving_size_count
    if self.serving_sizes.size > 10
      self.errors.add(:serving_sizes, "Cannot contain more than 10 serving sizes")
    end
  end
  
  def check_weight_volume
    #TODO: investigate why .count doesn't work
    #c = self.serving_sizes.count { |s| s.weight? }

    w = 0
    v = 0
    self.serving_sizes.each do |s|
      w += 1 if s.weight?
      v += 1 if s.volume?
    end
    
    if w > 1 || v > 1
      self.errors.add(:serving_sizes, "Only one weigth and volume serving size is allowed per consumable.")
    end
  end
end
