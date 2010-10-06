class Product
  include MongoMapper::Document
  
  key :name, :required => true
  
  key :user_id
  belongs_to :user
  
  many :recipes, :foreign_key => :product_ids
  
  many :food_entries, :as => 'consumable' 
  many :serving_sizes, :class_name => 'ServingSize'

  validates_associated :serving_sizes
  # Find all recipes with ingredient
  # Recipe.find("ingredients" => { :$elemMatch => {"_id" => "salt"} })
end
