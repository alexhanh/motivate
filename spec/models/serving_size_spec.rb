# coding: utf-8
require 'spec_helper'

describe ServingSize do
  before(:all) do 
    #@product = Factor(:product)
  end
   
  it "should have nutrition data if it's a root" do 
    s = Factory(:gramma)
 
    s.depth.should == 0
    s.nutrition_data.nil? == false
    s.valid?.should == true
    
    s.nutrition_data = nil
    s.valid?.should == false
  end 

  context "custom unit" do
    it "should have singular and plural forms" do
      p = Factory(:aakkoset)

      s = p.serving_sizes.last
      s.custom?.should == true
      s.singular.nil?.should == false
      s.plural.nil?.should == false
      s.valid?.should == true
      
      s.singular = nil
      s.valid?.should == false
      s.singular = "pussi"
      
      s.valid?.should == true
      s.plural = nil
      s.valid?.should == false
    end
  end
  
  context "relationships" do
    it 'should have a parent and parent amount if depth is greater than zero' do
      p = Factory(:aakkoset)
     
      s = p.serving_sizes.last
      s.parent_amount = nil
      s.root?.should == false
      s.valid?.should == false
    end
    
    it 'should not be valid if inheritance is too deep' do
      p = Factory(:aakkoset)

      s = ServingSize.new(:unit => 3,
                          :parent_amount => 10,
                          :singular => "lÄÄtikko", 
                          :plural => 'laatikkoa')
                          
      p.serving_sizes << s
      s.parent = p.serving_sizes[2]

      s.depth.should == 3

      p.valid?.should == false
      s.parent = p.serving_sizes[0]
      p.valid?.should == true
      
      p.save
      p p.serving_sizes
    end
  end
  
  context 'nutrition data' do
    it 'should update all inherited serving sizes upon change' do
      
    end
    
    it 'should scale nutrition data properly for inherited serving sizes' do
      p = Factory(:aakkoset)
      s = p.serving_sizes.last

      s.singular.should == "pussi"
      s.compute_data(2).protein.should == 150
    end
  end
end
