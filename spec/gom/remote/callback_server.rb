require File.dirname(__FILE__)+'/../../spec_helper'

describe Gom::Remote::CallbackServer do

  describe "initialization" do
    it "should not be running on creation" do
      cs = Gom::Remote::CallbackServer.new {} 
      cs.running?.should == false
    end

    it "should insist on a callback handler" do
      lambda {Gom::Remote::CallbackServer.new}.should raise_error
    end
  end

  describe "with a server" do
    before :each do
      @cs = Gom::Remote::CallbackServer.new {} 
    end

    it "should start and stop" do
      @cs.start.should == @cs
      sleep 1
      @cs.running?.should == true
      @cs.stop.should == @cs
      sleep 1
      @cs.running?.should == false
    end
  end
end
