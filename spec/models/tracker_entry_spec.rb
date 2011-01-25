# coding: utf-8
require 'spec_helper'

describe MetricLog do
  before do 
    user = User.new
    @m = Metric.new({ :name => "Test", :unit_type => Units::WEIGHT_TYPE })
    @l = MetricLog.new({ 
      :value => 1.0, 
      :unit => Units::GRAM, 
      :logged_on => Date.today,
      :user => user,
      :metric => @m 
    })
  end
  
  it 'should not validate if unit is float' do
    @l.valid?.should == true
    @l.unit = 0.0
    @l.valid?.should == false
  end
end
