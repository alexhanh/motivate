class User
  include MongoMapper::Document
  plugin MongoMapper::Devise

  devise :registerable, :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

   # NOTE: "Devise doesn’t use attr_accessible or attr_protected inside its modules, 
   # =>    so be sure to define attributes as accessible or protected in your model."
         
  key :username, :unique => true
  key :email, String
  

  
  many :food_entries
  many :recipes
 
end
