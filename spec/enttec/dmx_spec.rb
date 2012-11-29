require File.dirname(__FILE__)+'/../spec_helper'

describe Rdmx::Dmx do

  describe "initialization" do
    it "should initialize a serial port object on the given device" do
      SerialPort.should_receive(:new).with('/tmp/test',
        {'baud' => 115_200, 'data_bits' => 8, 'stop_bits' => 2, 'parity' => SerialPort::NONE})
      Rdmx::Dmx.new('/tmp/test')
    end
  end

  describe "packetizing" do
    it "should pad correctly" do
      Rdmx::Dmx.packetize(1).should == ["\x7E","\x06", "\x02", "\x00", "\x00", "\x01", "\xE7"]
    end

    it "works with byte arguments" do
      expect { Rdmx::Dmx.packetize("\x00") }.to_not raise_error
    end

    it "works with integer arguments" do
      expect { Rdmx::Dmx.packetize(0) }.to_not raise_error
    end

    it "should remove padding" do
      Rdmx::Dmx.depacketize(Rdmx::Dmx.packetize(1).join).should == [1]
    end
  end

  describe "with a dmx port" do
    let(:dmx) { Rdmx::Dmx.new '/tmp/test' }

    describe "writing" do
      it "should convert to a packet and write to the port" do
        @port.should_receive(:write).with("\x7E\x06\x03\x00\x00\x01\x02\xE7")
        dmx.write(1, 2)
      end
    end

    describe "reading" do
      it "should read from the port and convert from a DMX packet" do
        @port.should_receive(:read).and_return("\x7E\x06\x03\x00\x00\x01\x02\xE7")
        dmx.read.should == [1, 2]
      end
    end
  end
end
