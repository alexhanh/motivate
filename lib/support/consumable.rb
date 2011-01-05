module Support
module Consumable
  def self.included(klass)
    klass.class_eval do
      extend ClassMethods
      include InstanceMethods
      include MongoMapper::NestedAttributes
      
      many :serving_sizes, :class_name => 'ServingSize'
      accepts_nested_attributes_for :serving_sizes
      many :food_entries, :as => 'consumable' 
      
      validates_associated :serving_sizes
      validate :check_serving_size_count
      validate :check_weight_volume
    end
  end
  
  module InstanceMethods
    
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
      self.serving_sizes.each do |s|
        hash[s.unit_name] = s.unit_name if s.unit.custom?
        hash[s.unit_name] = s.unit unless s.unit.custom?
        # TODO: add perhaps a few more common units for weight and volume (if volume, then dl+cup+etc.)
      end
      
      return hash
    end
  end
  
  module ClassMethods
  end
end
end
