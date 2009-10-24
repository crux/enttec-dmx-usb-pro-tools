module Enttec

  # needs:
  #   GOM DMX Service Node URL which includes a device_file attribute and a
  #   values subnode: 
  #
  #   +-- /services/enttec-dmx-usb-pro
  #        |
  #        |-- :device_file
  #        |
  #        +-- values
  #              |-- :1
  #              |-- :5
  #             ...
  #              +-- :27
  # 
  class DmxNode

    Defaults = { }

    attr_reader :url, :path, :gom

    # dmx_node_url: http://<gom server>/<dmx node path>
    #
    def initialize url, options = {}
      @url = url
      @options = (Defaults.merge options)
      @gom, @path = (Gom::Remote::Connection.init url)

      @values = (Array.new 256, 0)
    end

    def device_file
      @device_file ||= (@gom.read "#{@path}:device_file.txt")
    end

    def values
      require 'nokogiri'
      xml = (@gom.read "#{@path}/values.xml")
      (Nokogiri::parse xml).xpath("//attribute").each do |a|
        chan = Integer(a.attributes['name'].to_s)
        @values[chan] = Integer(a.text)
      end

      @values
    end

    def on_values &callback
      raise "not yet implemented"
      @on_values_cb = callback
    end
  end
end
