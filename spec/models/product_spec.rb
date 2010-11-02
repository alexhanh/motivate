require 'spec_helper'

describe Product do
  before do
    @p = Factory(:aakkoset)
  end

  it 'should require a name' do
    @p.name = nil
    @p.valid?.should == false
  end

  it 'should contain only one weight serving size' do
    @p.serving_sizes << Factory(:gramma)
    @p.serving_sizes.last.valid?.should == true

    @p.valid?.should == false
  end

  it 'should contain only one volume serving size' do
    @p.serving_sizes << Factory(:litra)

    @p.valid?.should == false    
  end

  it 'should not be valid if it contains more than 10 serving sizes' do
    5.times { @p.serving_sizes << Factory(:candy) }
    @p.valid?.should == true
    5.times { @p.serving_sizes << Factory(:candy) }
    @p.valid?.should == false
  end
  
  it 'should not be valid if it contains more than one serving size with same names' do
    @p.serving_sizes << ServingSize.new(:unit => Units::CUSTOM,
                                       :singular => "foo", 
                                       :plural => "bar",
                                       :nutrition_data => Factory(:nutrition_data))
    @p.valid?.should == true
    
    @p.serving_sizes.last.singular = @p.serving_sizes[1].singular

    @p.valid?.should == false
  end

  it 'should compute nutrition data given quantity and unit' do
    @p.compute_data(1, Units::LITER).protein.should == 1
    @p.compute_data(23.5, Units::LITER).protein.should == 23.5
    @p.compute_data(1, Units::CUSTOM, "pussi").protein.should == 75
  end

  context 'update' do
    it 'should update cached product name in recipes' do
    
    end
    
    it 'should update cached nutrition data in recipes default serving size' do
    
    end
  end
end
