# TODO: Use the inflector to add pluralizations
# Probably should store in a database and load the whole database into memory on startup,
# The triplet <locale, singular, plural>
# Use a binary search tree to optimize the search (or some other sort of structure)

# todo: Gets inflection rules based on /config/locales/plurals.rb

# Note: Inflector simply uses a Ruby Hash, which might not be optimal.
# If performance becomes a bottleneck, should investigate alternative hash 
# implementations and/or data structures, such as tries, red black trees and 
# binary search tree. 

# About the ruby hash performance: http://www.igvita.com/2009/02/04/ruby-19-internals-ordered-hash/
# There are some good ones here: https://github.com/kanwei/algorithms

# This code is based on https://github.com/svenfuchs/i18n/blob/master/lib/i18n/backend/pluralization.rb
# class Inflector
#   def initialize
#     @hash = Hash.new # { :word => {:zero => "zero", :one => "one", :few => "few", :many => "many", :other => "other" } }
#     @pluralizers = {}
#   end
#   
#   def add(locale, inflections)
#     inflections.each_value do |inflection|
#       @hash[inflection] = inflections
#     end
#   end
# 
#   def pluralize(word, count)
#     pluralizer = pluralizer(I18n.locale)
#     
#     if pluralizer.respond_to?(:call)
#       key = count == 0 && entry.has_key?(:zero) ? :zero : pluralizer.call(count)
#       raise InvalidPluralizationData.new(entry, count) unless entry.has_key?(key)
#       hash[word][pluralizer.call(count)]
#     else
#       super
#     end
#   end
#   
#   private
#   def pluralizer(locale)
#     pluralizers[locale] ||= I18n.t(:'i18n.plural.rule', :locale => locale, :resolve => false)
#   end
# end

class Unit
  CUSTOM      = 0
  # KILOGRAM    = 101
  # GRAM        = 102
  # MILLIGRAM   = 103
  # MICROGRAM   = 104
  # 
  # LITER       = 201
  # DECILITER   = 202
  # CENTILITER  = 203 
  # MILLILITER  = 204
  # SPICEMEASURE= 205
  # TEASPOON    = 206
  # TABLESPOON  = 207
  # COFFEESPOON = 208
  # CUP         = 209
  # 
  # METER       = 301
  # CENTIMETER  = 302
  
  CUSTOM_TYPE = 0
  WEIGHT_TYPE = 1
  VOLUME_TYPE = 2
  LENGTH_TYPE = 3
  
  TYPES = [CUSTOM_TYPE, WEIGHT_TYPE, VOLUME_TYPE, LENGTH_TYPE]
  
  # Cache stuff for optimization
  @@NAME_MAP = {}
  self.constants.each do |c|
    cs = c.to_s
    @@NAME_MAP[const_get(c)] = cs.underscore unless cs =~ /TYPE/
  end
  
  attr_reader :scale, :type, :id, :custom_name
  
  # Creates a new unit. First parameter is either the unique unit id or
  # a non-numeric string for a custom unit. Yaml is used to lookup the 
  # translation for non-custom units. Scale tells how this unit
  # relates to the base unit of this unit type.
  def initialize(id, yaml=nil, scale=1.0)
    return if id.nil?
    if (id.is_a?(Numeric) || id.is_i?)
      @id = id.to_i
    else
      @id = CUSTOM
      @custom_name = id
    end
    @type = get_type
    @yaml = yaml
    @scale = scale
  end
    
  def id
    return @custom_name if custom?
    @id
  end
  
  # Returns true, if the types match for non-custom units.
  # Returns true, if the custom names match for custom units.
  def loose_match?(unit)
    return false if @type != unit.type
    return false if custom? && @custom_name.casecmp(unit.custom_name) != 0
    true
  end
  
  def abbreviate(count=1.0)
    (custom?)? pluralize(count) : I18n.t("units.#{@yaml}.abbrevation", :default => pluralize(count))
  end
  
  # See /config/locales/plurals.rb how pluralization rules are defined
  def pluralize(count)
    if custom?
      # todo: make a search from the custom inflector, if doesn't match, simply fallback to @name
      # something like OurInflector.pluralize(@name) || @name
      return @custom_name
    else
      (count == 1 || count =~ /^1([\.,]0+)?$/) ? 
        I18n.t("units.#{@yaml}", :count => 1) : I18n.t("units.#{@yaml}", :count => count)
    end
  end
  
  def custom?
    @type == CUSTOM_TYPE
  end    
  
  def convertable_to?(to)
    @type == to.type
    @custom_name == to.custom_name
  end
  
  def convert(to)
    @scale / to.scale
  end
  
  protected
  def get_type
    return CUSTOM_TYPE if @id == 0
    return WEIGHT_TYPE if @id > 100 && @id < 200
    return VOLUME_TYPE if @id > 200 && @id < 300
    return WEIGHT_TYPE if @id > 300 && @id < 400
    return LENGTH_TYPE if @id > 400 && @id < 500
  end
end