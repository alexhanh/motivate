module Support
module Consumable
  def self.included(klass)
    klass.class_eval do
      extend ClassMethods
      include InstanceMethods
      include MongoMapper::NestedAttributes
      
      many :serving_sizes, :class_name => 'ServingSize', :dependent => :destroy
      accepts_nested_attributes_for :serving_sizes, :allow_destroy => true
      validates_associated :serving_sizes
      
      many :food_entries, :as => 'consumable' 
      
      validate :check_serving_size_count
      validate :check_weight_volume
    end
  end
  
  module InstanceMethods
    
    def find_serving_size(unit, custom_unit=nil)
      wanted_type = unit.unit_type
      self.serving_sizes.each do |s|
        if s.unit.unit_type == wanted_type
          if unit.custom?
            if (custom_unit.casecmp(s.custom_unit) == 0)
              return s
            end
          else
            return s
          end
        end
      end
    end
    
    def compute_data(quantity, unit, custom_name=nil)
      # wanted_type = unit.unit_type
      # self.serving_sizes.each do |s|
      #   if s.unit.unit_type == wanted_type
      #     if unit.custom?
      #       if (custom_name.casecmp(s.custom_name))
      #         return s.compute_data(quantity) 
      #       end
      #     else
      #       return s.compute_data(Units::to_base(quantity, unit))
      #     end
      #   end
      # end
      s = find_serving_size(unit, custom_name)
      return if s.nil?
      return s.compute_data(quantity) if s.custom?
      return s.compute_data(Units::to_base(quantity, unit))
    end
    
    def check_serving_size_count
      if self.serving_sizes.size > 10
        self.errors.add(:serving_sizes, "Cannot contain more than 10 serving sizes.")
      end
    end
    
    def check_weight_volume
      #TODO: investigate why .count doesn't work
      #c = self.serving_sizes.count { |s| s.weight? }
      w = 0
      v = 0
      self.serving_sizes.each do |s|
        w += 1 if s.weight?
        v += 1 if s.volume?
      end
    
      if w > 1 || v > 1
        self.errors.add(:serving_sizes, 
        "Only one weigth and volume serving size is allowed per consumable.")
      end
    end
    
    def to_units
      hash = Hash.new
      has_weight = false
      has_volume = false
      self.serving_sizes.each do |s|
        hash[s.unit_name] = s.unit_name if s.unit.custom?
        has_weight = true if s.unit.weight?
        has_volume = true if s.unit.volume?
      end
      
      add_units = []
      add_units = add_units + Units::CommonWeight if has_weight
      add_units = add_units + Units::CommonVolume if has_volume
      
      add_units.each { |u| hash[u.unit_name] = u }
      
      return hash
    end
  end
  
  module ClassMethods
  end
end
end
