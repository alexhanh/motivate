# coding: utf-8
module Units
   
  CUSTOM      = 1
  KILOGRAM    = 11
  GRAM        = 12
  MILLIGRAM   = 13
  MICROGRAM   = 14
  
  LITER       = 1001
  DECILITER   = 1002
  CENTILITER  = 1003  
  MILLILITER  = 1004
  SPICEMEASURE= 1005
  TEASPOON    = 1006
  TABLESPOON  = 1007
  COFFEESPOON = 1008
  CUP         = 1009
  
  METER       = 10001
  CENTIMETER  = 10002
  
  All = {}
  Common = [GRAM, DECILITER, MILLILITER, TEASPOON, TABLESPOON, CUP]
  CommonWeight = [GRAM]
  CommonVolume = [DECILITER, MILLILITER, TEASPOON, TABLESPOON, CUP]
  
  Scales = {GRAM => 1.0, LITER => 1.0, METER => 1.0}

  Scales[KILOGRAM] =    Scales[GRAM]*1000
  Scales[MILLIGRAM] =   Scales[GRAM]/1000
  Scales[MICROGRAM] =   Scales[GRAM]/1000000
  
  Scales[DECILITER] =   Scales[LITER]/10
  Scales[CENTILITER] =  Scales[LITER]/100
  Scales[MILLILITER] =  Scales[LITER]/1000

  Scales[SPICEMEASURE] =Scales[MILLILITER]
  Scales[COFFEESPOON] = Scales[MILLILITER]*3
  Scales[TEASPOON] =    Scales[MILLILITER]*5
  Scales[TABLESPOON] =  Scales[MILLILITER]*15
  Scales[CUP] =         Scales[MILLILITER]*250
  
  Scales[CENTIMETER] =  Scales[METER]/100
  
  def self.convert(quantity, from, to)
    raise "Incompatible conversion" if from.unit_type != to.unit_type
    raise "Cannot convert custom units" if from.custom?
    
    quantity*Scales[from]/Scales[to]
  end
  
  # given a unit, returns it in the base unit of the unit's type
  def self.to_base(quantity, unit)
    return quantity if unit.custom?
    return convert(quantity, unit, Units::GRAM) if unit.weight?
    return convert(quantity, unit, Units::LITER) if unit.volume?
    return convert(quantity, unit, Units::METER) if unit.length?
  end
   
  def self.norm(s)
    s.downcase
    # s[0].downcase + s[1, s.length - 1].gsub(/([A-Z])/, "_\\1").downcase
  end
   
  def self.names
    All.each_value.collect { |v| I18n.t("units.#{v.to_s.downcase}.name") }
  end
  
  def self.common_names
    Common.each.collect { |v| I18n.t("units.#{All[v].to_s.downcase}.name") }
  end
  
  # def self.is_valid?(s)
  #   s.to_i.valid_unit? if s.is_i? 
  # end
  
  def self.find_code_by_string(s)
    # All.each do |key,value|
    #       return key if I18n.t("units.#{value.to_s.downcase}.name").casecmp(s) == 0
    #     end
    return s.to_i if s.is_i?
    
    Units::CUSTOM
  end
  
  def self.find_string_by_code(code)
    All.each do |key,value|
      return I18n.t("units.#{value.to_s.downcase}.name") if key == code
    end
  end

  self.constants.each do |c|
    s = norm(c.to_s)
    klass = self
    All[klass.const_get(c)] = c
    Numeric.class_eval do
      define_method(s+"?") do
        self == klass.const_get(c)
      end
    end
  end
  
  CUSTOM_TYPE      = 0
  WEIGHT_TYPE      = 10  
  VOLUME_TYPE      = 1000
  LENGTH_TYPE      = 10000
  
  Types = [CUSTOM_TYPE, WEIGHT_TYPE, VOLUME_TYPE, LENGTH_TYPE]
  
  Numeric.class_eval do
    define_method("unit_type") do
      if (self == Units::CUSTOM_TYPE ||
          self == Units::WEIGHT_TYPE ||
          self == Units::VOLUME_TYPE ||
          self == Units::LENGTH_TYPE)
        raise "Cannot call unit_type for unit type"
      end
      
      return Units::LENGTH_TYPE if self > 10000
      return Units::VOLUME_TYPE if self > 1000
      return Units::WEIGHT_TYPE if self > 10
      return Units::CUSTOM_TYPE    
    end
    
    
    define_method("length?") do
      self.unit_type == Units::LENGTH_TYPE
    end
    define_method("weight?") do
      self.unit_type == Units::WEIGHT_TYPE
    end
    define_method("volume?") do
      self.unit_type == Units::VOLUME_TYPE
    end
    define_method("custom?") do
      self.unit_type == Units::CUSTOM_TYPE
    end
    define_method("valid_unit?") do
      Units::All.has_key?(self)
    end
    define_method("unit_name") do
      @name ||= I18n.t("units.#{Units::All[self].to_s.downcase}.name", :default => Units::All[self].to_s.downcase) if self.valid_unit? && !self.custom?
    end
    define_method("base") do
      return self if custom?
      return Units::GRAM if weight?
      return Units::LITER if volume?
      return Units::METER if length?
    end
  end
end
