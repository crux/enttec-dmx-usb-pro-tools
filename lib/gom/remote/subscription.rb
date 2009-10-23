module Gom
  module Remote
    class Subscription
      
      Defaults = {
        :operations       => [:update],
        :condition_script => nil, 
        :uri_regexp       => nil,
      }

      attr_reader :name, :entry_uri, :uri

      def initialize name, entry_uri, handler = nil, options = {}, &blk
        @options = Defaults.merge options
        @name = name
        @entry_uri = entry_uri
        @handler = handler || blk;

        # URI for the observer node 
        @uri = "/gom/observer#{@entry_uri.sub ':', '/'}"
      end

      def 
    end
  end
end
