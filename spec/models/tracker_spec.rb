# coding: utf-8
require 'spec_helper'

describe Metric do
  before do 
    @m = Metric.new({ :name => "Test", :unit_type => Units::WEIGHT_TYPE })
  end
   
  it "should define which type of units it supports" do 
    @m.respond_to?(:unit_type).should == true
  end
  
  it "should not validate if unit type is missing" do
    @m.unit_type = nil
    @m.valid?.should == false
  end
  
  it "should validate if unit type is set" do
    @m.unit_type = Units::WEIGHT_TYPE
    @m.valid?.should == true
    @m.unit_type = -1
    @m.valid?.should == false
  end
  
  it "should not validate without a name" do
    @m.name = nil
    @m.valid?.should == false
  end
end
