class FoodEntry
  include MongoMapper::Document
 
  key :quantity, Float
  key :unit, Integer
  
  # cached values
  # TODO: fire up job to replace custom_unit_name with updated value and calls update_data
  key :custom_unit, String
  one :nutrition_data
 
  #key :consumable_name, String
 
  key :user_id, ObjectId
  belongs_to :user
  
  key :consumable_id, ObjectId
  key :consumable_type, String
  belongs_to :consumable, :polymorphic => true
  
  key :eaten_at, Date, :default => Date.today
  
  # todo: add validation for date? http://stackoverflow.com/questions/1370926/rails-built-in-datetime-validation
  
  #todo: fix me or the code querying!
  scope :on_date, lambda { |date|
    today = date.to_time.in_time_zone("UTC").beginning_of_day 
    tomorrow = (date+1.day).to_time.in_time_zone("UTC").beginning_of_day 
    where( 
      :eaten_at.gte => today, 
      :eaten_at.lt => tomorrow 
    ) 
  }
  
  validates_presence_of :quantity
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0.0
  
  #after_create :update_data
  #before_safe :update_consumable_name
  
  def unit_proxy
    return if self.unit.nil?
    return self.custom_unit if self.unit.custom?
    return self.unit
  end
  
  def unit_proxy=(s)
    if s.is_i?
      self.unit = s.to_i
    else
      self.unit = Units::CUSTOM
      self.custom_unit = s
    end
  end
  
  # def update_consumable_name
  #   self.consumable_name = consumable.name
  # end
  
  def update_data
    self.nutrition_data = consumable.compute_data(self.quantity, self.unit, self.custom_unit)
  end
end
