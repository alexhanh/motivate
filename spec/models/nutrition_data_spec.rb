require 'spec_helper'

describe NutritionData do
  it 'should scale' do
    n = NutritionData.new(:energy => 1,:carbs => 1, :protein => 1, :fat => 1)
    n.scale(10)
    
    n.energy.should == 10
    n.carbs.should == 10
    n.protein.should == 10
    n.fat.should == 10
  end
end
