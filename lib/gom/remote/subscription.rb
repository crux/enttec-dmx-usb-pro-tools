module Gom
  module Remote
    class Subscription
      
      Defaults = {
        :name             => nil,
        :operations       => [:update],
        :condition_script => nil, 
        :uri_regexp       => nil,
        :handler          => nil, 
      }

      attr_reader :name, :entry_uri, :options, :uri

      # hint: supplying a recognizable name helps with distributed gom
      # operations 
      #
      def initialize entry_uri, options = {}, &blk
        @name = options[:name] || "0x#{object_id}"
        @options = Defaults.merge options
        @name = name
        @entry_uri = entry_uri
        @handler = options[:handler] || blk;

        # URI for the observer node 
        @uri = "/gom/observer#{@entry_uri.sub ':', '/'}/.#{@name}"
      end
    end
  end
end
