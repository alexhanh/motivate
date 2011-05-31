# Run with rspec spec/lib/quantity_spec.rb in RAILS_ROOT dir

Dir[File.expand_path('./lib/support/*.rb')].each {|f| require f}

describe Quantity do
  it 'should work with comparisons' do
    (1.km < 2.km).should == true
    (2.km > 1.km).should == true
    (1.km == 1000.m).should == true
    (1.km < 1.mi).should == true
  end
  
  it 'should scale' do
    1.m.scale(10).value.should == 10
    (1.m*10).value.should == 10
  end
  
  it 'should add and substract' do
    one_kg = 1.kg
    two_kg = 2.kg
    
    result = one_kg - two_kg
    result.value.should == -1
    (result.unit.id == Units.kg.id).should == true
    
    hundred_grams = 100.g
    result = one_kg - hundred_grams
    result.value.should == 0.9
    (result.unit.id == Units.kg.id).should == true
  end
end