class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :birthday, :gender, :time_zone
  
  has_many :favorites, :dependent => :destroy
  has_many :food_entries, :dependent => :destroy
  has_many :consumables #hmm, scopella recipet ja productit erikseen?
                        # scope where type == food tjsp
  has_many :exercises, :dependent => :destroy
  has_many :exercise_entries, :dependent => :destroy
  has_many :tracker_entries
  
  has_many :achievements

  def weight_change_rate_q
    Quantity.new(weight_change_rate, Units.kg)
  end

  def favorite?(favorable)
    !favorite(favorable).nil?
  end
  
  def favorite(favorable)
    self.favorites.where(:favorable_id => favorable.id, :favorable_type => favorable.class.name, :user_id => self.id).first
  end
  
  def male?
    self.gender
  end
  
  def female?
    !self.gender
  end
  
  # Returns the newest weight before given date or nil if no entries exist
  def weight_at(time)
    weight_entries = self.tracker_entries.joins(:tracker).where("trackers.name = ?", "weight")
    closest_in_past = weight_entries.where("logged_on < ?", time.utc).order(:logged_on).last
    
    if closest_in_past
      closest_in_past.quantity
    end
  end

  # Returns the newest height (cm) before given date or nil if no entries exist  
  def height_at(time)
    height_entries = self.tracker_entries.joins(:tracker).where("trackers.name = ?", "height")
    closest_in_past = height_entries.where("logged_on < ?", time.utc).order(:logged_on).last
    
    if closest_in_past
      closest_in_past.quantity
    end
  end
  
  # TODO: This is not 100% accurate. See http://quaran.to/blog/2008/10/13/calculating-age-in-rails/
  def age
    today = Date.current
    age = today.year - birthday.year
    age -= 1 if today < birthday + age.years
    age
  end
  
  def bmr(time)
    # Make use of users weight entries, if they exist
    weight = weight_at(time)
    height = height_at(time)

    # Fallback to default values
    weight ||= male? ? 80.kg : 70.kg
    height ||= male? ? 168.cm : 157.cm
    
    # TODO: Note, we don't multiply by 1.2!! See http://en.wikipedia.org/wiki/Harris-Benedict_equation
    FoodScience.harris_benedict(weight, height, age, gender)
  end
end