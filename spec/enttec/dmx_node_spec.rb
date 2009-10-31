require File.dirname(__FILE__)+'/../spec_helper'

describe Enttec::DmxNode do

  include Enttec

  describe "initialization" do
    it "should initialize with GOM node path" do
      _, path = (Gom::Remote::Connection.init 'http://dmx:345/dmx/node')
      dmx = (Enttec::DmxNode.new path)
      dmx.path.should == '/dmx/node'
    end
  end

  describe "with a values GNP message" do
    before :each do
      @gom, path = (Gom::Remote::Connection.init 'http://dmx:345/dmx/node')
      @gom.should_not == nil
      @dmx = (Enttec::DmxNode.new path)

      @values = (Array.new 512, 0)
      @dmx.stub!(:values).and_return(@values)
      @device = Object.new
      @dmx.stub!(:device).and_return(@device)
    end

    it "should write values GNP to device" do
      values = (Array.new 512, 0)
      values[1] = 255
      @device.should_receive(:write).with(*values)
      (@dmx.send :value_gnp, :update, {"name" => "1", "value" => "255"})
    end
  end

  describe "with a dmx node it" do
    before :each do
      @gom, path = (Gom::Remote::Connection.init 'http://dmx:345/dmx/node')
      @gom.should_not == nil
      @dmx = (Enttec::DmxNode.new path)
    end

    it "should load the device_file name" do
      @gom.should_receive(:read).
        with("/dmx/node:device_file.txt").
        and_return('/dev/cu.usbserial-ENRV27QZ')
      @dmx.device_file.should == '/dev/cu.usbserial-ENRV27QZ'
    end

    it "should have 512 entries in the values array" do
      @gom.should_receive(:read).with('/dmx/node/values.xml').and_return(<<-XML)
<?xml version="1.0"?>
<node ctime="2009-10-22T17:14:31+02:00" uri="/dmx/node/values" name="values" mtime="2009-10-22T17:14:31+02:00">
</node>
        XML
      @dmx.values.size.should == 512
    end

    it "should reject non integer DMX values" do
      @gom.should_receive(:read).with('/dmx/node/values.xml').and_return(<<-XML)
<?xml version="1.0"?>
<node ctime="2009-10-22T17:14:31+02:00" uri="/dmx/node/values" name="values" mtime="2009-10-22T17:14:31+02:00">
<attribute type="string" name="4" mtime="2009-10-22T17:14:31+02:00">abc</attribute>
</node>
        XML
      a = (Array.new 512, 0)
      @dmx.values.should == a
    end

    it "should reject out of range DMX values" do
      @gom.should_receive(:read).with('/dmx/node/values.xml').and_return(<<-XML)
<?xml version="1.0"?>
<node ctime="2009-10-22T17:14:31+02:00" uri="/dmx/node/values" name="values" mtime="2009-10-22T17:14:31+02:00">
<attribute type="string" name="2" mtime="2009-10-22T17:14:31+02:00">300</attribute>
<attribute type="string" name="3" mtime="2009-10-22T17:14:31+02:00">54321</attribute>
</node>
        XML
      a = (Array.new 512, 0)
      @dmx.values.should == a
    end

    it "should reject out or range DMX channels" do
      @gom.should_receive(:read).with('/dmx/node/values.xml').and_return(<<-XML)
<?xml version="1.0"?>
<node ctime="2009-10-22T17:14:31+02:00" uri="/dmx/node/values" name="values" mtime="2009-10-22T17:14:31+02:00">
<attribute type="string" name="600" mtime="2009-10-22T17:14:31+02:00">1</attribute>
<attribute type="string" name="0" mtime="2009-10-22T17:14:31+02:00">23</attribute>
<attribute type="string" name="1" mtime="2009-10-22T17:14:31+02:00">-10</attribute>
</node>
        XML
      a = (Array.new 512, 0)
      @dmx.values.should == a
    end

    it "should parse values from gom node" do
      @gom.should_receive(:read).with('/dmx/node/values.xml').and_return(<<-XML)
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
