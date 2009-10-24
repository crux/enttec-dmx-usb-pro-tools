require File.dirname(__FILE__)+'/spec_helper'

describe Gom::Remote::Subscription do

  describe "with a Remote::Connection" do 
    before :each do
      @gom, _ = (Gom::Remote::Connection.init 'http://localhost:3000')
    end
  end

  it "should overwrite name from options value" do
    name = "test-#{Time.now.to_i}"
    s = (Gom::Remote::Subscription.new '/node/values', :name => name)
    s.name.should == name
  end

  describe "when created with default options" do
    before :each do
      @sub = (Gom::Remote::Subscription.new '/dmx/node/values')
    end
    it "should have a object id as name" do
      @sub.name.should == "0x#{@sub.object_id}"
    end
    it "should have operations whitelist" do
      @sub.operations.should == "update"
    end
    it "should have nil condition_script" do
      @sub.condition_script.should == nil
    end
    it "should have a nil uri_regexp" do
      @sub.uri_regexp.should == nil
    end
  end

  describe "observer uri" do
    it "should construct a proper gom observer uri" do
      s = (Gom::Remote::Subscription.new '/dmx/node/values')
      s.uri.should == "/gom/observer/dmx/node/values/.#{s.name}"
    end
    it "should interpret attribute paths" do
      s = (Gom::Remote::Subscription.new '/dmx/node:attribute')
      s.uri.should == "/gom/observer/dmx/node/attribute/.#{s.name}"
    end
  end
end
