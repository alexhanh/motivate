module Support
  module Consumable
    def self.included(klass)
      klass.class_eval do
        extend ClassMethods
        include InstanceMethods
        include Support::Favorable

        has_many :food_units, :as => :consumable, :dependent => :destroy
        has_many :food_entries, :as => :consumable
        has_many :favorites, :as => :favorable, :dependent => :destroy
        
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
        nil
      end
    end

    module ClassMethods
    end
  end
end
