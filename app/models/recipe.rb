class Recipe < ActiveRecord::Base
  include Motivate::Consumable
  
  belongs_to :user
    
  validates_presence_of :name
end