class User
  include MongoMapper::Document
  plugin MongoMapper::Devise

  devise :registerable, :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  
  key :roles_mask, Integer

   # NOTE: "Devise doesn’t use attr_accessible or attr_protected inside its modules, 
   # =>    so be sure to define attributes as accessible or protected in your model."
         
  #key :username, :unique => true
  key :email, String, :unique => true
  
  many :food_entries
  many :recipes
  
  many :favorites
  
  #////////////
  # Roles
  #////////////

  # todo: figure out how to do this in MM if something like this is needed
  #scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }
  
  ROLES = %w[admin user]
  
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  
  def role?(role)
    roles.include? role.to_s
  end
  
  #//////////////
  # Uncathegorized
  #//////////////
  def favorite?(favorable)
    !favorite(favorable).nil?
  end
  
  def favorite(favorable)
    self.favorites.first(:favorable_id => favorable.id, :user_id => self.id) #needs favorable_type?
  end
end
