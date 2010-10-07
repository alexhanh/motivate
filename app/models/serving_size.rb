# coding: utf-8
# do *not* add more than one serving size without saving in between
# this will risk screwing up depth otherwise
# this actually has been fixed by calling set_depth in parent=.. test to confirm

# inherit servable or mixin servable?
class ServingSize
  include MongoMapper::EmbeddedDocument
  
  key :parent_amount, Float
  key :depth, Integer, :default => 0

  key :unit, Integer # 0 custom, 10 =< weight <= 1000, 2000 =< volume <= 3000  ... 
                     # or simply 1 for weight and 2 for volume and 3 for custom and assume grams and liters
  key :singular, String
  key :plural, String
  
  key :parent_id, ObjectId

  one :nutrition_data
  #embedded_in :product
  #belongs_to :product

  before_save :set_depth

  before_validation :downcase_inflections, :on => :create

  #TODO: add error messages  
  #TODO: replace lambdas with with_options
  validates_presence_of :parent_amount, :parent_id, :if => lambda { |s| !s.root? }
  validates_numericality_of :parent_amount, :greater_than => 0, :if => lambda { |s| !s.root? }
  validates_format_of :singular, :plural, :with => /\A[[:alpha:] ]+\Z/, :if => lambda { |s| !s.root? }
  
  validates_length_of :singular, :plural, :in => 1..20, :if => lambda { |s| s.custom? }
  validates_presence_of :nutrition_data, :if => lambda { |s| s.root? }
  
  validates_numericality_of :depth, :less_than_or_equal_to => 2
  
  #/////////////////////////
  # Validations
  #/////////////////////////
  
  #/////////////////////////
  # Units
  #/////////////////////////
  
  def weight?
    self.unit == 1
  end
  
  def volume?
    self.unit == 2
  end
  
  def custom?
    self.unit == 3
  end
  
  def compute_data(quantity=1)
    p = self
    factor = 1.0
    until p.root?
      factor *= p.parent_amount
      p = p.parent
    end
    
    return p.nutrition_data.scale(factor*quantity)
  end
  
  #/////////////////////////
  # Relationships
  #/////////////////////////
  
  def parent
    find(self.parent_id) unless self.parent_id.blank?
  end
  
  def parent=(p)
    if p.nil?
      self.parent_id = nil
    else
      self.parent_id = p.id
      set_depth
    end
  end
  
  def root
    p = self
    p = p.parent until p.parent_id.nil?
    
    return p
  end
  
  def root?
    self.depth.zero?
  end
  
  
  private
  
  def find(id)
    self._root_document.serving_sizes.each do |s|
      return s if s.id == id
    end
  end
  
  def set_depth
    unless self.parent_id.blank?
      self.depth = self.parent.depth + 1
    end
  end
  
  #/////////////////////////
  # Helpers
  #/////////////////////////
  
  def downcase_inflections
    #TODO: monkey-patch string.downcase and use ActiveSupport (mbchars) instead
    self.singular = Unicode::downcase(singular.strip) if singular
    self.plural = Unicode::downcase(plural.strip) if plural
  end
end
