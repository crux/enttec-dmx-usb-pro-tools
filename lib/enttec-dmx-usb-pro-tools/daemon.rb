module Enttec
  class Daemon

    include ::Timeout

    Defaults = { 
      :refresh_interval_dt => 10
    }

    # dmx_node_url: http://<gom server>/<dmx node path>
    #
    def initialize dmx_node_url, options = {}
      @options = (Defaults.merge options)
      @dmx = DmxNode.new dmx_node_url, @options
    end

    def run
      puts " -- running gom enttec daemon loop..."
      grcs = Gom::Remote::CallbackServer.new
      grcs.start
      loop do
        begin
          tic
        rescue => e
          puts " ## #{e}"
        end
        sleep @options[:refresh_interval_dt]
      end
    ensure
      grcs.stop
    end

    private

    def tic
      puts " -- tic --"
      values = {}
      @dmx.values.each_with_index do |val, i|
        (0 < val) and (values[i+1] = val)
      end
      puts values.inspect
    end
  end
end

__END__

upload_handler = lambda do |env|
  params = Rack::Request.new(env).params
  
  fname = params["Filename"]
  tmpfile = params["Filedata"][:tempfile]
  payload = JSON.parse(params["foo"])
  
  destination = generate_destination_path(fname)
  FileUtils.mv tmpfile.path, destination
  res = Net::HTTP.post_form(URI.parse('http://127.0.0.1:3000/admin/testme'), params.merge({'file_path'=> path, 'max'=>'50'}))
  
  [200, {"Content-Type"=>"text/plain"}, ["gabba"]]
end

def generate_destination_path(oldname)
  extension = File.extname(oldname)
  File.join(ImageDir, MD5.new(oldname).to_s + extension)
end

Rack::Handler::Mongrel.run(upload_handler, {
  :Host => "127.0.0.1", :Port => 8080
})
# 
