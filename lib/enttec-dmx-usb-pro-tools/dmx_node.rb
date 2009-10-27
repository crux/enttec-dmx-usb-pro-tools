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
  class DmxNode < Gom::Remote::Entry
    
    Defaults = { }

    attr_reader :path

    # dmx_node_url: http://<gom server>/<dmx node path>
    #
    def initialize path, options = {}
      @path = path
      @options = (Defaults.merge options)

      @values_sub = Subscription.new(
        "#{@path}/values", 
        :name => "enttec-dmx", :operations => [:update, :create]
      )
      @values_sub.callback = lambda { |*args| value_gnp(*args) }
      connection.subscribe @values_sub
    end

    def device_file
      @device_file ||= (connection.read "#{@path}:device_file.txt")
    end

    def values
      data = (Array.new 512, 0)

      xml = (connection.read "#{@path}/values.xml")
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

    def value_gnp op, attribute
      chan, val = attribute["name"], (Integer attribute["value"])
      puts " -- DMX Node #{op}: Channel(#{chan}) == #{val}"
    end

    def validate_dmx_range chan, value
      if(chan < 1 or 512 <= chan)
        raise " ## warning: DMX channel out of range: #{chan}"
      end
      if(value < 0 or 256 <= value) 
        raise " ## warning: DMX value out of range: #{value}"
      end
    end
  end
end
