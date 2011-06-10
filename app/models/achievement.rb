class Achievement < ActiveRecord::Base
  TYPES = %w[gold silver bronze]
  
  GOLD = %w[highlander]
  SILVER = %w[marathonist]
  BRONZE = %w[measurer popular_product]
  
  belongs_to :user
  
  def self.TOKENS
    @tokens ||= GOLD + SILVER + BRONZE
  end
  
  validates_inclusion_of :token, :in => self.TOKENS
  
  before_save :set_type
  
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
  
  protected
  def set_type
    if BRONZE.include?(token)
      self.achievement_type = 'bronze'
    elsif SILVER.include?(token)
      self.achievement_type = 'silver'
    elsif GOLD.include?(token)
      self.achievement_type = 'gold'
    end
  end
end