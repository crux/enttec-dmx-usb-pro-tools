require File.dirname(__FILE__)+'/spec_helper'

describe Gom::Remote::Subscription do

  describe "with a Remote::Connection" do 
    before :each do
      @gom, _ = (Gom::Remote::Connection.init 'http://localhost:3000')
    end
  end

  describe "when created with default options" do
    before :each do
      @sub = (Gom::Remote::Subscription.new '/dmx/node/values')
    end
    it "should have a object id as name" do
      @sub.name.should == "0x#{@sub.object_id}"
    end
    it "should have operations whitelist" do
      @sub.options[:operations].should == [:update]
    end
    it "should have nil condition_script" do
      @sub.options.has_key?(:condition_script).should == true
      @sub.options[:condition_script].should == nil
    end
    it "should have a nil uri_regexp" do
      @sub.options.has_key?(:uri_regexp).should == true
      @sub.options[:uri_regexp].should == nil
    end
  end

  describe "observer uri" do
    it "should construct a proper gom observer uri" do
      s = (Gom::Remote::Subscription.new '/dmx/node/values')
      s.uri.should == '/gom/observer/dmx/node/values'
    end
    it "should interpret attribute paths" do
      s = (Gom::Remote::Subscription.new '/dmx/node:attribute')
      s.uri.should == '/gom/observer/dmx/node/attribute'
    end
  end
end
