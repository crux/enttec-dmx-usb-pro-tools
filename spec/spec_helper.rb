$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'enttec-dmx-usb-pro-tools'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.before :each do
    @port = stub('SerialPort', :write => nil)
    SerialPort.stub!(:new).and_return(@port)

    @gom = stub('Gom::Remote::Connection', :write => nil)
    (Gom::Remote::Connection.stub! :new).and_return @gom
  end

  config.after :each do
  end
end
