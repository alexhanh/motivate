class Quantity
  include Comparable
  
  attr_reader :value, :unit
  
  def unit_id
    @unit.id
  end
  
  def initialize(value, unit)
    @value = value.to_f
    if (unit.is_a?(Unit))
      @unit = unit
    else
      @unit = Units.find_or_create_custom(unit)
    end
  end
  
  def round(precision = 0)
    precision > 0 ? @value.round(precision) : @value.round
  end
  
  def convert(to)
    raise "Incompatible conversion" unless @unit.convertable_to?(to)
    Quantity.new(@value*@unit.convert(to), to)
  end
  
  def scale(multiplier)
    Quantity.new(@value*multiplier, @unit)
  end
  def *(multiplier)
    scale(multiplier)
  end
  
  def add(q)
    Quantity.new(self.value + q.convert(self.unit).value, self.unit)
  end
  def +(q)
    add(q)
  end
  
  def substract(q)
    Quantity.new(self.value - q.convert(self.unit).value, self.unit)
  end
  def -(q)
    substract(q)
  end
  
  def divide(s)
    Quantity.new(@value/s, @unit)
  end
  def /(s)
    divide(s)
  end
  
  def <=>(q)
    self.convert(q.unit).value <=> q.value
  end
  
  def to_s(options = {})
    format = options[:format] || :short
    digits = options[:digits] || 1
    number_part = "#{round(digits)} "
    
    case format
      when :short
        number_part + @unit.abbreviate(@value)
      when :long
        number_part + @unit.pluralize(@value)
    end
  end
  
  #////
  # Unit method short hands
  #////
  def type
    @unit.type
  end
  
  def custom?
    @unit.custom?
  end
  
  def weight?
    @unit.type == Unit::WEIGHT_TYPE
  end
  
  def energy?
    @unit.type == Unit::ENERGY_TYPE
  end
  
  def length?
    @unit.type == Unit::LENGTH_TYPE
  end
end