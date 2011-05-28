# Run with rspec spec/lib/quantity_spec.rb in RAILS_ROOT dir

Dir[File.expand_path('./lib/support/*.rb')].each {|f| require f}

describe Quantity do
  it 'should work with comparisons' do
    (Quantity.new(1, Units.km) < Quantity.new(2, Units.km)).should == true
    (Quantity.new(2, Units.km) > Quantity.new(1, Units.km)).should == true
    (Quantity.new(1, Units.km) == Quantity.new(1000, Units.m)).should == true
    (Quantity.new(1, Units.km) < Quantity.new(1, Units.mi)).should == true
  end
  
  it 'should scale' do
    Quantity.new(1, Units.m).scale(10).value.should == 10
    (Quantity.new(1, Units.m)*10).value.should == 10
  end
  
  it 'should add and substract' do
    one_kg = Quantity.new(1, Units.kg)
    two_kg = Quantity.new(2, Units.kg)
    
    result = one_kg - two_kg
    result.value.should == -1
    (result.unit.id == Units.kg.id).should == true
    
    hundred_grams = Quantity.new(100, Units.g)
    result = one_kg - hundred_grams
    result.value.should == 0.9
    (result.unit.id == Units.kg.id).should == true
  end
end