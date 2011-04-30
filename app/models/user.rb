class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  
  has_many :favorites, :dependent => :destroy
  has_many :food_entries, :dependent => :destroy
  has_many :consumables #hmm, scopella recipet ja productit erikseen?
                        # scope where type == food tjsp
  has_many :exercises, :dependent => :destroy
  has_many :tracker_entries
  
  def favorite?(favorable)
    !favorite(favorable).nil?
  end
  
  def favorite(favorable)
    self.favorites.where(:favorable_id => favorable.id, :favorable_type => favorable.class.name, :user_id => self.id).first
  end
end