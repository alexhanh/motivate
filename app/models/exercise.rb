class Exercise < ActiveRecord::Base
  has_many :exercise_entries
  
  validates_presence_of :name
  
  def running?
    self.name == "running"
  end
  
  def lname
    @lname ||= I18n.t("exercises.#{self.name}")
  end
end