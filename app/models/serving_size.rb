# do *not* add more than one serving size without saving in between
# this will risk screwing up depth otherwise
# this actually has been fixed by calling set_depth in parent=.. test to confirm

# inherit servable or mixin servable?

# for weight, nutrition_data should be always stored per one gram
# for volume, nutrition_data should be always stored per one liter
# for custom, nutrition_data should be always stored per one custom unit
# :unit expressed the unit in which 
class ServingSize
  include MongoMapper::EmbeddedDocument
  include MongoMapper::NestedAttributes

  attr_accessor :quantity
 
  # expresses in which units user originally expressed the relation
  # so that we can build "purkki ~ 1 litra" again instead of "purkki ~ 1000 ml"
  # it should only be set when this is inherited
  # for custom, it remains custom
  # for volume it is ml,cl,dl,l,teaspoon, etc.
  # for weight is is ug, mg, g, kg
  # this only affects how the relation will be rendered
  key :parent_display_unit, Integer # TODO: if nil, use parent unit
  key :parent_amount, Float
  key :depth, Integer, :default => 0
  # parent unit's type should equal to parent.type
  
  key :unit, Integer 
                     
  key :singular, String
  key :plural, String
  #key :custom_name, String
  
  key :parent_id, ObjectId

  one :nutrition_data
  def nutrition_data_attributes=(d)
    self.nutrition_data = NutritionData.new(d)
  end
#  accepts_nested_attributes_for :nutrition_data

  #embedded_in :product
  #belongs_to :product

  before_save :set_depth
  before_save :normalize_units, :if => lambda { |s| !s.quantity.nil? }

  before_validation :downcase_inflections, :on => :create

  #TODO: add error messages  
  #TODO: replace lambdas with with_options
  validates_presence_of :parent_amount, :parent_id, :if => lambda { |s| !s.root? }
  validates_numericality_of :parent_amount, :greater_than => 0, :if => lambda { |s| !s.root? }
  #validates_numericality_of :parent_display_unit, :greater_than_or_equal_to => 0, :if => lambda { |s| !s.root? }
  validates_format_of :singular, :plural, :with => /\A[[:alpha:] ]+\Z/, :if => lambda { |s| !s.root? }
  
  validates_length_of :singular, :plural, :in => 1..20, :if => lambda { |s| s.custom? }
  validates_presence_of :nutrition_data, :if => lambda { |s| s.root? }

  validates_presence_of :unit
  validates_numericality_of :unit, :greater_than_or_equal_to => 0
  
  validates_numericality_of :depth, :less_than_or_equal_to => 2
  
  validate :inflection_uniqueness
  validate :unit_validness
  
  #/////////////////////////
  # Virtual attributes
  #/////////////////////////
  
  def unit_name=(s)
    self.unit = Units::find_code_by_string(s)
  end

  def unit_name
    return if self.unit.nil?
    return self.singular if self.unit.custom?

    Units::find_string_by_code(self.unit)
  end
  
  #attr_accessor :new_unit_name
  
  #/////////////////////////
  # Validations
  #/////////////////////////
  
  def inflection_uniqueness
    self._root_document.serving_sizes.each do |s|
      # since weight and volume gets validated by check_weight_volume
      # it is enough to check custom units
      if s.custom? && s.id != self.id && (
            self.singular == s.singular || 
            self.singular == s.plural ||
            self.plural == s.plural ||
            self.plural == s.singular)
        self.errors.add(:singular, "Serving size name is already taken.")
      end
    end
  end
  
  def unit_validness
    unless self.unit.valid_unit?
      self.errors.add(:test, "Not a valid unit.")
    end
  end
  
  #/////////////////////////
  # Units
  #/////////////////////////
  
  def weight?
    unit.weight?
  end
  
  def volume?
    unit.volume?
  end
  
  def custom?
    unit.custom?
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
  
  def normalize_units
    self.nutrition_data = self.nutrition_data.scale(1.0/Units::to_base(self.quantity.to_f, self.unit))
  end
  
  def downcase_inflections
    #TODO: monkey-patch string.downcase and use ActiveSupport (mbchars) instead
    self.singular = Unicode::downcase(singular.strip) if singular
    self.plural = Unicode::downcase(plural.strip) if plural
  end
end
