require File.dirname(__FILE__)+'/spec_helper'

describe Gom::Remote::Connection do

  describe "initialization" do
    it "should split a GOM node url on init" do
      gom, path = (Gom::Remote::Connection.init 'http://gom:345/dmx/node')
      gom.base_url.should == 'http://gom:345'
      path.should == '/dmx/node'
    end
  end

  describe "with subscriptions" do 
    before :each do
      @gom, path = (Gom::Remote::Connection.init 'http://localhost:3000')
      @gom.stub!(:callback_ip).and_return("1.2.3.4");
    end

    it "should have no subscriptions on init" do
      @gom.subscriptions.should == []
    end

    it "should put observer to gom on refresh" do
      s = (Gom::Remote::Subscription.new '/node/values')
      @gom.subscriptions.push s
      @gom.should_receive(:http_put).with(
        "http://localhost:3000/gom/observer/node/values/.#{s.name}", { 
        "attributes[callback_url]" => "http://1.2.3.4/gnp?#{s.name}:/node/values", 
        "attributes[accept]" => 'application/json'
      })
      @gom.refresh_subscriptions
    end

    it "should observe an attribute entry" do
      s = (Gom::Remote::Subscription.new '/node:attribute')
      @gom.should_receive(:http_put).with(
        "http://localhost:3000/gom/observer/node/attribute/.#{s.name}", { 
        "attributes[callback_url]" => "http://1.2.3.4/gnp?#{s.name}:/node:attribute", 
        "attributes[accept]" => 'application/json'
      })
      @gom.refresh s
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
