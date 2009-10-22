$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'enttec-dmx-usb-pro'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.before :each do
    @port = stub('SerialPort', :write => nil)
    SerialPort.stub!(:new).and_return(@port)
  end

  config.after :each do
  end
end
