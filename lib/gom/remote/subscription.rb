module Gom
  module Remote
    class Subscription
      
      Defaults = {
        :name             => nil,
        :operations       => [:update],
        :condition_script => nil, 
        :uri_regexp       => nil,
      }

      attr_reader :name, :entry_uri, :options, :uri

      #h hint: supplying a recognizable name helps with distributed gom
      # operations 
      #
      def initialize entry_uri, handler = nil, options = {}, &blk
        @name = options[:name] || "0x#{object_id}"
        @options = Defaults.merge options
        @name = name
        @entry_uri = entry_uri
        @handler = handler || blk;

        # URI for the observer node 
        @uri = "/gom/observer#{@entry_uri.sub ':', '/'}"
      end
    end
  end
end
