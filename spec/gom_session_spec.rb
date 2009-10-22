require File.dirname(__FILE__)+'/spec_helper'

describe Enttec::GomSession do

  include Enttec

  describe "initialization" do
    it "should initialize with GOM node URL" do
      Gom::Client.should_receive(:new).with('http://localhost:345')
      Enttec::GomSession.new('http://localhost:345/dmx/node/')

    end
  end

  describe "with a session it" do
    before :each do
      @dmx = Rdmx::Dmx.new '/tmp/test'
      @session = Enttec::GomSession.new('http://localhost:345/dmx/node')
    end

    #describe "config" do
      it "should fetch the node uri from the URL" do
        @session.node_uri.should == '/dmx/node'
      end

      it "should load the device_file name" do
        @gom.
          should_receive(:read).
          with('/dmx/node:device_file.txt').
          and_return('/dev/cu.usbserial-ENRV27QZ')
        @session.device_file.should == '/dev/cu.usbserial-ENRV27QZ'
      end

      it "should parse values from gom node" do
        @gom.
          should_receive(:read).
          with('/dmx/node/values.xml').
          and_return(<<-XML)
<?xml version="1.0"?>
<node ctime="2009-10-22T17:14:31+02:00" uri="/services/DMX/enttec-dmx-usb-pro/values" name="values" mtime="2009-10-22T17:14:31+02:00">
  <attribute type="string" name="1" mtime="2009-10-22T17:14:31+02:00">1</attribute>
  <attribute type="string" name="17" mtime="2009-10-22T17:14:31+02:00">23</attribute>
  <attribute type="string" name="245" mtime="2009-10-22T17:14:31+02:00">177</attribute>
</node>
          XML
        a = (Array.new 256, 0)
        a[1] = 1; a[17] = 23; a[245] = 177
        @session.values.should == a
      end
    #end
  end
end

__END__

  describe "packet construction" do
    it "should pad correctly" do
      Rdmx::Dmx.packetize(1).should == ["\x7E","\x06", "\x02", "\x00", "\x00", "\x01", "\xE7"]
    end

    it "should work with byte arguments" do
      lambda do
        Rdmx::Dmx.packetize("\x00")
      end.should_not raise_error
    end

    it "should work with integer arguments" do
      lambda do
        Rdmx::Dmx.packetize(0)
      end.should_not raise_error
    end
  end

  describe "packet deconstruction" do
    it "should remove padding" do
      Rdmx::Dmx.depacketize(Rdmx::Dmx.packetize(1).join).should == [1]
    end
  end

  describe "with a dmx port" do
    before :each do
      @dmx = Rdmx::Dmx.new '/tmp/test'
    end

    describe "writing" do
      it "should convert to a packet and write to the port" do
        @port.should_receive(:write).with("\x7E\x06\x03\x00\x00\x01\x02\xE7")
        @dmx.write(1, 2)
      end
    end

    describe "reading" do
      it "should read from the port and convert from a DMX packet" do
        @port.should_receive(:read).and_return("\x7E\x06\x03\x00\x00\x01\x02\xE7")
        @dmx.read.should == [1, 2]
      end
    end
  end
end
