class Product < ActiveRecord::Base
  include Support::Consumable
  include PgSearch
  
  pg_search_scope :search_by_name, :against => :name
  
  
  belongs_to :user
    
  validates_presence_of :name
end
