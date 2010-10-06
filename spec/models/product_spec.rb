require 'spec_helper'

describe Product do
  it 'should load from factory' do
    product = Factory(:product)
    product.valid?.should == true
    
    #User.create!(:email => 'wqee@ffoo.com', :password => 'asdas2424d')
    #user = Factory(:user)
  end

  it 'should require a name' do
    p = Product.new()
    p.valid?.should == false
    
    p.name = "Banana"
    p.valid?.should == true
  end

  context 'update' do
 
    it 'should update cached product name in recipes' do
    
    end
    
    it 'should update cached nutrition data in recipes default serving size' do
    
    end
    
    it '' do
      p = Product.new
      p.food_entries << FoodEntry.new
      
      p.save
      
#      c = FoodEntry.new
#      c.consumable = p
#      c.save
    end
  end
end
