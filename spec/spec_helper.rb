$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'enttec-dmx-usb-pro-tools'
require 'fakeweb'

RSpec.configure do |config|
  config.add_setting(
    :fixtures, :default => "#{File.dirname(__FILE__)}/fixtures",
    :alias_with => :fixtures
  )

  config.before :each do
    @port = stub('SerialPort', :write => nil)
    SerialPort.stub!(:new).and_return(@port)

    #@gom = stub('Gom::Remote::Connection', :write => nil)
    #(Gom::Remote::Connection.stub! :new).and_return @gom

    FakeWeb.register_uri(
      :get, "http://gom:345/gom/config/connection.txt", 
      :body => "client_ip: 10.0.0.23"
    )
  end

  config.after :each do
  end
end
