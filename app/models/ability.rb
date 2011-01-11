class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new

    can :read, :all
    can :update, FoodEntry, :user => user
  end
end