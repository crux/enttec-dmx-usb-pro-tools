module Enttec
  class GomSession

    Defaults = { }

    attr_reader :node_uri

    # dmx_node_url: http://<gom server>/<dmx node path>
    #
    def initialize dmx_node_url, options = {}
      @options = (Defaults.merge options)

      gom_url, @node_uri = (GomSession::split_url dmx_node_url)
      @gom = Gom::Client.new gom_url

      @values = (Array.new 256, 0)
    end

    def refresh
      raise "not yet implemented"
    end

    def values
      require 'nokogiri'
      xml = (@gom.read "#{@node_uri}/values.xml")
      (Nokogiri::parse xml).xpath("//attribute").each do |a|
        chan = Integer(a.attributes['name'].to_s)
        @values[chan] = Integer(a.text)
      end

      @values
    end

    def device_file
      @device_file ||= (@gom.read "#{@node_uri}:device_file.txt")
    end

    def on_values &callback
      raise "not yet implemented"
      @on_values_cb = callback
    end

    # take apart the URL into GOM and node path part
    def self.split_url url
      u = URI.parse url
      re = %r|#{u.scheme}://#{u.host}(:#{u.port})?|
      gom = (re.match url).to_s
      node = (url.sub gom, '')
      [gom, node]
    end
  end
end
