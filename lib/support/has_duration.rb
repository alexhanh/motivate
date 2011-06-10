# encoding: utf-8

# All this fucking hours, minutes and seconds getters and setters hack just to get durations and forms work nicely!
module Support
  module HasDuration
    def self.included(klass)
      klass.class_eval do
        extend ClassMethods
        include InstanceMethods
        
        validates_numericality_of :hours, :greater_than_or_equal_to => 0.0,   :only_integer => true, :allow_nil => true
        validates_numericality_of :minutes, :greater_than_or_equal_to => 0.0, :only_integer => true, :allow_nil => true
        validates_numericality_of :seconds, :greater_than_or_equal_to => 0.0, :only_integer => true, :allow_nil => true
        
        attr_accessor :hours, :minutes, :seconds
        
        before_validation :assign_duration
        
        def hours=(h)
          @hours = h unless h.blank?
        end
        
        def minutes=(m)
          @minutes = m unless m.blank?
        end
        
        def seconds=(s)
          @seconds = s unless s.blank?
        end
        
        def hours
          return @hours if @seconds || @minutes || @hours 
          if duration
            h = duration / 3600
            return h if h > 0
          end
        end

        def minutes
          return @minutes if @seconds || @minutes || @hours 
          if duration
            # h = duration / 3600
            # (duration - h * 3600) / 60
            m = (duration % 3600) / 60
            return m if m > 0
          end
        end
        
        def seconds
          return @seconds if @seconds || @minutes || @hours 
          if duration
            s = duration % 60
            return s if s > 0
          end
        end
      end
    end

    module InstanceMethods
      private
      def assign_duration
        errors.add(:duration, ' on määriteltävä') if @hours.blank? && @minutes.blank? && @seconds.blank?
        self.duration = (@hours || '0').to_i*60*60 + (@minutes || '0').to_i*60 + (@seconds || '0').to_i
      end
    end

    module ClassMethods
    end
  end
end
