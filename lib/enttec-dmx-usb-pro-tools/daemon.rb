module Enttec
  class Daemon

    include ::Timeout

    Defaults = { 
      :refresh_interval_dt => 60
    }

    # dmx_node_url: http://<gom server>/<dmx node path>
    #
    def initialize dmx_node_url, options = {}
      @options = (Defaults.merge options)
      @gom, dmx_node_path = (Gom::Remote::Connection.init dmx_node_url)
      @dmx = DmxNode.new dmx_node_path, @options
    end

    def run
      puts " -- running gom enttec daemon loop..."
      loop do
        begin
          tic
        rescue Exception => e
          puts " ## #{e}\n -> #{e.backtrace.join "\n    "}"
        end
        sleep @options[:refresh_interval_dt]
      end
    end

    private

    def tic
      puts " -- tic --"
      @gom.refresh
      #values = {}
      #@dmx.values.each_with_index do |val, i|
      #  (0 < val) and (values[i+1] = val)
      #end
      #puts values.inspect
    end
  end
end
