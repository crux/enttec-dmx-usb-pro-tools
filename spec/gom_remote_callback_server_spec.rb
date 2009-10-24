require File.dirname(__FILE__)+'/spec_helper'

describe Gom::Remote::CallbackServer do

  describe "initialization" do
    it "should not be running on creation" do
      Gom::Remote::CallbackServer.new.running?.should == false
    end

    it "should start and stop" do
      cs = Gom::Remote::CallbackServer.new
      cs.start.should == cs
      sleep 1
      cs.running?.should == true
      cs.stop.should == cs
      sleep 1
      cs.running?.should == false
    end
  end
end
