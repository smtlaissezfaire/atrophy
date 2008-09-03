require File.dirname(__FILE__) + "/../spec_helper"

describe "toplevel" do
  it "should have the Atrophy constant as a module" do
    Atrophy.should be_a_kind_of(Module)
  end
end

describe Atrophy do
  it "should have the constant Runner" do
    lambda { 
      Atrophy::Runner
    }.should_not raise_error
  end
  
  it "should have the constant View" do
    lambda { 
      Atrophy::View
    }.should_not raise_error
  end
  
  it "should have the constant View" do
    lambda { 
      Atrophy::ViewFinder
    }.should_not raise_error
  end
end
