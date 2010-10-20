require 'spec_helper'

describe NutritionStats do
  it '' do
    10.times { |n| Factory(:food_entry, :quantity => n+1) }
    p 10.times.collect
    p 10.times.map
  end
  
  it 'should sum up properly the stats' do
    s = NutritionStats.new()
    10.times { s.add(Factory(:food_entry)) }
    s.protein.should == 375
    p s.energy
  end
end
