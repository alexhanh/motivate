require 'spec_helper'

describe Units do
  it 'should give the right unit types' do
    Units::GRAM.unit_type.should == Units::WEIGHT_TYPE
    Units::GRAM.weight?.should == true
    Units::LITER.unit_type.should == Units::VOLUME_TYPE
    Units::LITER.volume?.should == true
    Units::CUSTOM.unit_type.should == Units::CUSTOM_TYPE
    Units::CUSTOM.custom?.should == true
  end
  
  it 'should raise expection if type? checker is used on a type' do
    lambda {Units::CUSTOM.unit_type}.should_not raise_error
    lambda {Units::CUSTOM_TYPE.unit_type}.should raise_error
    lambda {Units::WEIGHT_TYPE.unit_type}.should raise_error
    lambda {Units::VOLUME_TYPE.unit_type}.should raise_error
  end
  
  it 'should convert units properly' do
    Units::convert(5, Units::KILOGRAM, Units::GRAM).should == 5000.0
    Units::convert(2.5, Units::DECILITER, Units::CENTILITER).should == 25.0
    Units::convert(1, Units::CUP, Units::CUP).should == 1
  end
  
  it 'should raise exception if incompatible conversion is tried' do
    lambda {Units::convert(1, Units::GRAM, UNITS::DECILITER)}.should raise_error
    lambda {Units::convert(1, Units::CUSTOM, UNITS::DECILITER)}.should raise_error
  end
  
  it 'should give false for not valid units' do
    Units::GRAM.valid_unit?.should == true
    (-1).valid_unit?.should == false
    Units::WEIGHT_TYPE.valid_unit?.should == false
    Units::CUSTOM.valid_unit?.should == true
  end
  
  it 'should give a unit name for valid units' do
    p Units::GRAM.unit_name
    p Units::WEIGHT_TYPE.unit_name
    Units::GRAM.unit_name.nil?.should == false
    Units::WEIGHT_TYPE.unit_name.nil?.should == true
  end
end
