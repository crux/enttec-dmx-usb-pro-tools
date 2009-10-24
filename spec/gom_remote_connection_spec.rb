require File.dirname(__FILE__)+'/spec_helper'

describe Gom::Remote::Connection do

  describe "initialization" do
    it "should split a GOM node url on init" do
      gom, path = (Gom::Remote::Connection.init 'http://gom:345/dmx/node')
      gom.base_url.should == 'http://gom:345'
      path.should == '/dmx/node'
    end
  end

  describe "with a connection it" do
    before :each do
      @gom, path = (Gom::Remote::Connection.init 'http://gom:345/dmx/node')
    end

    it "should fetch the callback_ip from remote" do
      @gom.should_receive(:read).
        with("/gom/config/connection.txt").
        and_return('client_ip: 0.0.0.0')
      @gom.callback_ip.should == "0.0.0.0"
    end
  end
end
