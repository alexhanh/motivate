class Product < ActiveRecord::Base
  include Support::Consumable
  include PgSearch
  
  pg_search_scope :search_by_name, :against => [:name, :brand]
  
  scope :uniquely_branded, select("DISTINCT(products.brand)")#group(:id, :brand)
    
  belongs_to :user
    
  validates_presence_of :name
  
  validates_length_of :brand, :in => 1..15, :allow_blank => true
end