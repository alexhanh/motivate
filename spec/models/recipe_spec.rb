require 'spec_helper'

describe Recipe do
  before(:all) do 
  end
  
  it '' do
    p = Product.new(:name => 'Soijamaito')
    s = ServingSize.new(:unit => 1) # weight
    s.nutrition_data = NutritionData.new(:energy => 100, :carbs => 50, :protein => 3, :fat => 20)
    p.serving_sizes << s
    
    p.save
    p.reload
    
    p.serving_sizes.size.should == 1
    p.serving_sizes.first.weight?.should == true

    b = Product.new(:name => 'Banaani')
    s = ServingSize.new(:unit => 1) # weight
    s.nutrition_data = NutritionData.new(:energy => 50, :carbs => 30, :protein => 12, :fat => 14)
    b.serving_sizes << s
    
    b.save
    b.reload
    
    s = ServingSize.new(:unit => 3, :singular => 'keskikokoinen banaani', :plural => 'keskikokoista banaania') # custom
    s.parent = b.serving_sizes.first
    b.serving_sizes << s

    b.save
    b.reload
    
    b.serving_sizes.size.should == 2
    b.serving_sizes[1].parent_id.should == b.serving_sizes[0].id
    
    b.serving_sizes[0].depth.should == 0
    b.serving_sizes[1].depth.should == 1
  
    r = Recipe.new(:name => 'Banaanipirtelo', :servings_produced => 4.0)
    i = Ingredient.new(:quantity => 1, :unit => 'dl')
    i.product = Product.first(:name => 'Soijamaito')
    
    r.ingredients << i
    
    i = Ingredient.new(:quantity => 2, :unit => 'keskikokoinen banaani')
    i.product = Product.first(:name => 'Banaani')
    
    r.ingredients << i
    
    r.save
  end
end


























































