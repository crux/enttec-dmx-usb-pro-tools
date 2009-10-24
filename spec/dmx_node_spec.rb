require File.dirname(__FILE__)+'/spec_helper'

describe Enttec::DmxNode do

  include Enttec

  describe "initialization" do
    it "should initialize with GOM node URL" do
      dmx = Enttec::DmxNode.new('http://gom:345/dmx/node')
      dmx.url.should == 'http://gom:345/dmx/node'
      dmx.path.should == '/dmx/node'
    end
  end

  describe "with a dmx node it" do
    before :each do
      @dmx = Enttec::DmxNode.new('http://dmx:345/dmx/node')
      @gom = Gom::Remote.connection
    end

    it "should load the device_file name" do
      @gom.should_receive(:read).
        with("/dmx/node:device_file.txt").
        and_return('/dev/cu.usbserial-ENRV27QZ')
      @dmx.device_file.should == '/dev/cu.usbserial-ENRV27QZ'
    end

    it "should reject invalid and out of range dmx values and channels" do
      @gom.
        should_receive(:read).
        with('/dmx/node/values.xml').
        and_return(<<-XML)
<?xml version="1.0"?>
<node ctime="2009-10-22T17:14:31+02:00" uri="/dmx/node/values" name="values" mtime="2009-10-22T17:14:31+02:00">
<attribute type="string" name="600" mtime="2009-10-22T17:14:31+02:00">1</attribute>
<attribute type="string" name="0" mtime="2009-10-22T17:14:31+02:00">23</attribute>
<attribute type="string" name="1" mtime="2009-10-22T17:14:31+02:00">-10</attribute>
<attribute type="string" name="2" mtime="2009-10-22T17:14:31+02:00">300</attribute>
<attribute type="string" name="3" mtime="2009-10-22T17:14:31+02:00">54321</attribute>
<attribute type="string" name="4" mtime="2009-10-22T17:14:31+02:00">abc</attribute>
</node>
        XML
      a = (Array.new 512, 0)
      @dmx.values.should == a
    end

    it "should parse values from gom node" do
      @gom.
        should_receive(:read).
        with('/dmx/node/values.xml').
        and_return(<<-XML)
<?xml version="1.0"?>
<node ctime="2009-10-22T17:14:31+02:00" uri="/dmx/node/values" name="values" mtime="2009-10-22T17:14:31+02:00">
<attribute type="string" name="1" mtime="2009-10-22T17:14:31+02:00">1</attribute>
<attribute type="string" name="17" mtime="2009-10-22T17:14:31+02:00">23</attribute>
<attribute type="string" name="245" mtime="2009-10-22T17:14:31+02:00">177</attribute>
</node>
        XML
      a = (Array.new 512, 0)
      a[0] = 1; a[16] = 23; a[244] = 177
      @dmx.values.should == a
    end
  end
end
