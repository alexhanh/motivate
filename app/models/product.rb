class Product < ActiveRecord::Base
  include Support::Consumable
  
  belongs_to :user
    
  validates_presence_of :name
end
