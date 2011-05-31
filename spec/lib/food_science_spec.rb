# Run with rspec spec/lib/food_science_spec.rb in RAILS_ROOT dir

Dir[File.expand_path('./lib/support/*.rb')].each {|f| require f}


describe FoodScience do
  def diff(val1, val2)
    (val1-val2).abs
  end
  
  it 'should produce proper results' do
    # Taken from https://sites.google.com/site/compendiumofphysicalactivities/corrected-mets (Table 1)
    diff(FoodScience.personalized_met(12.3, 60.kg, 168.cm, 35, :female), 13.5).should < 0.05
    diff(FoodScience.personalized_met(12.3, 77.kg, 168.cm, 55, :female), 16.5).should < 0.05
    diff(FoodScience.personalized_met(12.3, 70.kg, 178.cm, 35, :male), 12.9).should < 0.05
    diff(FoodScience.personalized_met(12.3, 91.kg, 178.cm, 55, :male), 15.4).should < 0.05
  end
end