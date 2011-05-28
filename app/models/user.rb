class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :birthday, :gender, :weight_unit_unit, :energy_unit_unit, :length_unit_unit
  
  has_many :favorites, :dependent => :destroy
  has_many :food_entries, :dependent => :destroy
  has_many :consumables #hmm, scopella recipet ja productit erikseen?
                        # scope where type == food tjsp
  has_many :exercises, :dependent => :destroy
  has_many :exercise_entries, :dependent => :destroy
  has_many :tracker_entries
  
  has_many :achievements
  
  composed_of :weight_unit, :class_name => 'Unit', :mapping => %w(weight_unit_unit id)
  composed_of :energy_unit, :class_name => 'Unit', :mapping => %w(energy_unit_unit id)
  composed_of :length_unit, :class_name => 'Unit', :mapping => %w(length_unit_unit id)
  
  composed_of :weight_change_rate, :class_name => "Quantity", :mapping => [%w(weight_change_rate_value value), %w(weight_change_rate_unit unit_id)]
  before_save :normalize_units
  def normalize_units
    self.weight_change_rate = self.weight_change_rate.convert(Units.kg)
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
  
  # Returns the newest weight (kg) before given date or nil if no entries exist
  def weight_at(time)
    weight_entries = self.tracker_entries.joins(:tracker).where("trackers.name = ?", "weight")
    closest_in_past = weight_entries.where("logged_on < ?", time).order(:logged_on).last
    
    if closest_in_past
      return closest_in_past.quantity.convert(Units.kg).value
    else
      return nil
    end
  end

  # Returns the newest height (cm) before given date or nil if no entries exist  
  def height_at(time)
    height_entries = self.tracker_entries.joins(:tracker).where("trackers.name = ?", "height")
    closest_in_past = height_entries.where("logged_on < ?", time).order(:logged_on).last
    
    if closest_in_past
      return closest_in_past.quantity.convert(Units.cm).value
    else
      return nil
    end
  end
  
  # TODO: This is not 100% accurate. See http://quaran.to/blog/2008/10/13/calculating-age-in-rails/
  def age
    age = Date.today.year - birthday.year

    age -= 1 if Date.today < birthday + age.years
    
    return age
  end
  
  def bmr(time, output_energy_unit=Units.kcal)
    # Make use of users weight entries, if they exist
    weight = weight_at(time)
    height = height_at(time)

    # Set default values
    if weight.nil?
      if male?
        weight = 80      
      else
        weight = 70
      end
    end
    
    # Harris-Benedict equation, assumes weight in kg, height in cm and age in years
    if male?
      return Quantity.new( (66.5 + (13.75 * weight) + (5.003 * height) - (6.775 * age))*1.2, Units.kcal).convert(output_energy_unit)
    else
      return Quantity.new( (655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * age))*1.2, Units.kcal).convert(output_energy_unit) * 1.2
    end
  end
end