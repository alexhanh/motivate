require 'spec_helper'

describe FoodEntry do
  before do
    @e = Factory(:food_entry)
  end

  it 'should update internal nutrition_data when consumable\'s data has changed' do
    original = @e.nutrition_data.protein
   
    @e.consumable.serving_sizes.each {|s| s.nutrition_data.protein *= 2 if s.root? }
    @e.update_data

    @e.nutrition_data.protein.should == original*2
  end
  
  it 'should update cache custom name when the serving size it references is changed' do
  end
end
