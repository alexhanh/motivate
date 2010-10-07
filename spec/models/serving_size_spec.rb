# coding: utf-8
require 'spec_helper'

describe ServingSize do
  before do 
    @p = Factory(:aakkoset)
  end
   
  it "should have nutrition data if it's a root" do 
    #s = Factory(:gramma)
    s = @p.serving_sizes.first
 
    s.depth.should == 0
    s.nutrition_data.nil? == false
    s.valid?.should == true
    
    s.nutrition_data = nil
    s.valid?.should == false
  end 

  context "inflections" do
    it 'should be downcased and work with non-english characters' do
      p = Factory(:aakkoset)
      
      p.valid?.should == true
      p.serving_sizes.last.singular = "äöå ÄÖÅФ ЫВА"
      p.valid?.should == true
      p.serving_sizes.last.singular.should == "äöå äöåф ыва"
    end
  end

  context "custom unit" do
    it "should have singular and plural forms" do
      s = @p.serving_sizes[2]
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
      s = @p.serving_sizes[2]
      s.parent_amount = nil
      s.root?.should == false
      s.valid?.should == false
    end
    
    it 'should not be valid if inheritance is too deep' do
      s = ServingSize.new(:unit => 3,
                          :parent_amount => 10,
                          :singular => "laatikko", 
                          :plural => 'laatikkoa')
                          
      @p.serving_sizes << s
      s.parent = @p.serving_sizes[2]

      s.depth.should == 3

      @p.valid?.should == false
      s.parent = @p.serving_sizes[0]
      @p.valid?.should == true
    end
  end
  
#  context 'update name' do
#    it 'should update cached names in recipes' do
#    
#    end
#  end

#  it 'should not be removable' do
#  
#  end
#  
#  context 'disable' do
#    it 'should not be referencable any more' do
#    
#    end
#  end
  
  context 'nutrition data' do
    it 'should update all inherited serving sizes upon change' do
      
    end
    
    it 'should scale nutrition data properly for inherited serving sizes' do
      s = @p.serving_sizes[2]

      s.singular.should == "pussi"
      s.compute_data(2).protein.should == 150
    end
  end
end
