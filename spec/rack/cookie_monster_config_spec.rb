require 'spec_helper'
require 'rack/cookie_monster'
require 'action_controller'

describe Rack::CookieMonsterConfig do
  subject { described_class }
  
  describe "#initialize" do
    it "does not require any options by default" do
      instance = subject.new
      instance.cookies.should be_empty
      instance.snackers.should be_empty
    end
    
    it "can be initialized with cookies and snackers" do
      instance = subject.new(
        :cookies => ["oatmeal", "raisen"],
        :share_with => ["Firefox", /flash/]
      )
      
      instance.cookies.should == [:oatmeal, :raisen]
      instance.snackers.should == ["Firefox", /flash/]
    end
    
    it "a cookie and snacker can be provided optionally outside of an array" do
      instance = subject.new(
        :cookies => "oatmeal",
        :share_with => "MSIE"
      )
      
      instance.cookies.should == [:oatmeal]
      instance.snackers.should == ["MSIE"]
    end    
  end
  
  describe "#eat" do
    it "collects param names" do
      instance = subject.new
      [:mojo, :phoebe, :moudgie].each do |x|
        instance.eat x
      end
      instance.cookies.should == [:mojo, :phoebe, :moudgie]
    end    
  end
  
  describe "#share_with" do
    it "collects snackers" do
      instance = subject.new      
      ["Flash", "MSIE"].each do |x|
        instance.share_with x
      end
      instance.snackers.should == ["Flash", "MSIE"]
    end
  end
end