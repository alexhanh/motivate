require 'spec_helper'
require 'benchmark'

describe NutritionData do
  it 'should scale' do
    n = NutritionData.new(:energy => 1, :carbs => 1, :protein => 1, :fat => 1)
    n = n.scale(10)
    
    n.energy.should == 10
    n.carbs.should == 10
    n.protein.should == 10
    n.fat.should == 10
  end
  
  it "should fail if energy isn't defined or is not positive" do
    n = Factory(:nutrition_data, :energy => nil)
    n.valid?.should == false
    n.energy = -2
    n.valid?.should == false
  end
  
  it "should fail if protein isn't defined or is not positive" do
    n = Factory(:nutrition_data, :protein => nil)
    n.valid?.should == false
    n.protein = -2
    n.valid?.should == false
  end
  
  it "should fail if carbs isn't defined or is not positive" do
    n = Factory(:nutrition_data, :carbs => nil)
    n.valid?.should == false
    n.carbs = -2
    n.valid?.should == false
  end
  
  it "should fail if fats isn't defined or is not positive" do
    n = Factory(:nutrition_data, :fat => nil)
    n.valid?.should == false
    n.fat = -2
    n.valid?.should == false
  end
end
