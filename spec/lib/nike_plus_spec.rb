require 'rubygems'
require './lib/nike_plus.rb'
require 'pp'

describe NikePlus do
  it "should do something" do
    NikePlus.get_runs('1759895612')
  end
end