class User
  include MongoMapper::Document
  plugin MongoMapper::Devise

  devise :registerable, :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
         
  key :username, :unique => true
  key :email, String
end
