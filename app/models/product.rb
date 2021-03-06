class Product < ActiveRecord::Base
  include Motivate::Consumable
  include PgSearch
  
  pg_search_scope :search_by_name, :against => [:name, :brand], :using => { :tsearch => { :prefix => true } }
  
  scope :uniquely_branded, select("DISTINCT(products.brand)")#group(:id, :brand)
    
  belongs_to :user
    
  validates_presence_of :name
  
  validates_length_of :brand, :in => 1..15, :allow_blank => true
end