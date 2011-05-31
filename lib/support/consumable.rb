module Support
  module Consumable
    def self.included(klass)
      klass.class_eval do
        extend ClassMethods
        include InstanceMethods
        include Support::Favorable

        has_many :food_units, :as => :consumable, :dependent => :destroy
        has_many :food_entries, :as => :consumable
        
        # http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html
        accepts_nested_attributes_for :food_units, :allow_destroy => true
        
        validates_associated :food_units
      end
    end

    module InstanceMethods
      def find_food_unit(unit)
        self.food_units.each do |fu|
          return fu if fu.quantity.unit.loose_match?(unit)
        end
      end
      
      # Computes Food::Data for a given quantity ("100g") or
      # returns nil if no compatible unit conversion can be done.
      def compute_data(quantity)
        food_unit = find_food_unit(quantity.unit)
        return nil if food_unit.nil?

        food_unit.food_data.scale(quantity.convert(food_unit.quantity.unit).value/food_unit.value)
      end
    end

    module ClassMethods
    end
  end
end
