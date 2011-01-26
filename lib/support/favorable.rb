module Support
module Favorable
    def self.included(klass)
    klass.class_eval do
      extend ClassMethods
      include InstanceMethods
      key :favorites_count, Integer, :default => 0
      many :favorites, :as => "favorable", :dependent => :destroy
      #has_many :favoriting_users, :through => :favorites, :source => :user
    end
  end

  module InstanceMethods
    def add_favorite!(user)
      self.increment({:favorites_count => 1})
    end

    def remove_favorite!(user)
      self.increment({:favorites_count => -1})
    end
  end

  module ClassMethods
  end
end
end