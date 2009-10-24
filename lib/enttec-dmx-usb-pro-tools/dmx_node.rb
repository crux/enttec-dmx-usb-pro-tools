require 'nokogiri'

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
    
    include Gom::Remote

    Defaults = { }

    attr_reader :url, :path, :gom

    # dmx_node_url: http://<gom server>/<dmx node path>
    #
    def initialize url, options = {}
      @url = url
      @options = (Defaults.merge options)
      @gom, @path = (Gom::Remote::Connection.init url)

      @values_sub = (Subscription.new "#{@path}/values", :name => "enttec-dmx")
      @gom.subscriptions.push @values_sub
    end

    def device_file
      @device_file ||= (@gom.read "#{@path}:device_file.txt")
    end

    def values
      data = (Array.new 512, 0)

      xml = (@gom.read "#{@path}/values.xml")
      (Nokogiri::parse xml).xpath("//attribute").each do |a|
        begin
          chan = Integer(a.attributes['name'].to_s)
          val = Integer(a.text)
          validate_dmx_range chan, val
          data[chan-1] = val
        rescue => e
          puts e
        end
      end

      data
    end

    def validate_dmx_range chan, value
      if(chan < 1 or 512 <= chan)
        raise " ## warning: DMX channel out of range: #{chan}"
      end
      if(value < 0 or 256 <= value) 
        raise " ## warning: DMX value out of range: #{value}"
      end
    end

    def on_values &callback
      raise "not yet implemented"
      @on_values_cb = callback
    end
  end
end
