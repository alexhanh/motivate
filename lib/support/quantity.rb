class Quantity
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
    @value.round(precision)
  end
  
  def convert(to)
    raise "Incompatible conversion" unless @unit.convertable_to?(to)
    Quantity.new(@value*@unit.convert(to), to)
  end
  
  def to_s(options = {})
    format = options[:format] || :short
    digits = options[:digits] || 1
    case format
      when :short
        "#{round(digits)} " + @unit.abbreviate(@value)
      when :long
        "#{round(digits)} " + @unit.pluralize(@value)
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
end