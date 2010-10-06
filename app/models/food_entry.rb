class FoodEntry
  include MongoMapper::Document
 
  belongs_to :user
  
  belongs_to :consumable, :polymorphic => true
end
