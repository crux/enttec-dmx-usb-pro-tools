module Gom
  module Remote
    class Daemon

      include ::Timeout

      Defaults = { 
        :refresh_interval_dt => 60
      }

      # dmx_node_url: http://<gom server>/<dmx node path>
      #
      def initialize url, options = {}, &blk
        @options = (Defaults.merge options)
        @gom, path = (Gom::Remote::Connection.init url)
        #@dmx = DmxNode.new dmx_node_path, @options
        (blk.call path) unless blk.nil?
      end

      def run &tic
        puts " -- running gom enttec daemon loop..."
        loop do
          begin
            puts " -- tic --"
            @gom.refresh
            tic && (tic.call self)
          rescue Exception => e
            puts " ## #{e}\n -> #{e.backtrace.join "\n    "}"
          end
          sleep @options[:refresh_interval_dt]
        end
      end
    end
  end
end
