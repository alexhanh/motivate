# coding: utf-8

class Units
  
  # Weight
  def self.gram
    @gram ||= Unit.new(101, "gram", 1.0)
  end
  
  def self.kilogram
    @kilogram ||= Unit.new(102, "kilogram", 1000.0)
  end
  
  def self.milligram
    @milligram ||= Unit.new(103, "milligram", 1.0/1000)
  end
  
  def self.microgram
    @microgram ||= Unit.new(104, "microgram", 1.0/1000000)
  end
  
  # Volume
  def self.liter
     @liter ||= Unit.new(201, "liter")
  end
  
  def self.deciliter
    @deciliter ||= Unit.new(202, "deciliter", 1.0/10)
  end
  
  def self.centiliter
    @centiliter ||= Unit.new(203, "centiliter", 1.0/100)
  end
  
  def self.milliliter
    @milliliter ||= Unit.new(204, "milliliter", 1.0/1000)
  end
  
  def self.spicemeasure
    @spicemeasure ||= Unit.new(205, "spicemeasure", 1.0/1000)
  end
  
  def self.teaspoon
    @teaspoon ||= Unit.new(206, "teaspoon", 5.0/1000)
  end

  def self.tablespoon
    @tablespoon ||= Unit.new(207, "tablespoon", 15.0/1000)
  end

  
  def self.coffeespoon
    @coffeespoon ||= Unit.new(208, "coffeespoon", 3.0/1000)
  end
  
  def self.cup
    @liter ||= Unit.new(209, "cup", 250.0/1000)
  end
  
  # Length
  def self.meter
    @meter ||= Unit.new(301, "meter")
  end
  
  def self.centimeter
    @centimeter ||= Unit.new(302, "centimeter", 1.0/100)
  end
  
  # Add aliases
  class << self
    alias :g :gram
    alias :kg :kilogram
    alias :mg :milligram
    alias :mcg :microgram
    alias :dl :deciliter
    alias :ml :milliliter
    alias :cl :centiliter
    alias :l :liter
    alias :tspn :teaspoon
    alias :ts :teaspoon
    alias :tsp :teaspoon
    alias :tbsp :tablespoon
    alias :tbs :tablespoon
    alias :m :meter
    alias :cm :centimeter
  end
  
  # Cache stuff for optimization
  @@ID_MAP = {}
  self.singleton_methods(false).each do |m|
    unit = self.method(m).call
    @@ID_MAP[unit.id.to_s] = unit
  end
  
  # Finds a predefined unit from given id string 
  # (a number) or creates a custom unit if not found.
  def self.find_or_create_custom(id)
    return @@ID_MAP[id] if @@ID_MAP.has_key?(id)
    Unit.new(id)
  end
end