require File.dirname(__FILE__)+'/spec_helper'

describe Gom::Remote::Subscription do

  describe "when created with default options" do
    it "should have operations whitelist" do
      s = (Gom::Remote::Subscription.new 'foo', '/dmx/node/values')
      s.options[:operations].should == [:update]
    end

    it "should have nil condition_script" do
      s = (Gom::Remote::Subscription.new 'foo', '/dmx/node/values')
      s.options.has_key?(:condition_script).should == true
      s.options[:condition_script].should == nil
    end

    it "should have a nil uri_regexp" do
      s = (Gom::Remote::Subscription.new 'foo', '/dmx/node/values')
      s.options.has_key?(:uri_regexp).should == true
      s.options[:uri_regexp].should == nil
    end
  end

  describe "observer uri" do
    it "should construct a proper gom observer uri" do
      s = (Gom::Remote::Subscription.new 'foo', '/dmx/node/values')
      s.uri.should == '/gom/observer/dmx/node/values'
    end
    it "should interpret attribute paths" do
      s = (Gom::Remote::Subscription.new 'foo', '/dmx/node:attribute')
      s.uri.should == '/gom/observer/dmx/node/attribute'
    end
  end
end
