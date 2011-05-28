class Achievement < ActiveRecord::Base
  ACHIEVEMENTS = %w[measurer marathonist popular_product highlander]
  
  belongs_to :user
  
  def self.TOKENS
    @tokens ||= ACHIEVEMENTS
  end
  
  validates_inclusion_of :token, :in => self.TOKENS
  
  def name
    @name ||= I18n.t("achievements.#{self.token}.name")
  end
  
  def description
    @description ||= I18n.t("achievements.#{self.token}.description")
  end
  
  def source=(s)
    if s
      self.source_id = s.id
      self.source_type = s.class.to_s
    else
      self.source_id = nil
      self.source_type = nil
    end
  end
  
  def source
    if self.source_type
      @cached_source ||= self.source_type.constantize.find(self.source_id)
    end
  end
end