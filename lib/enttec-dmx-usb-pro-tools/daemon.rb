module Enttec
  class Daemon

    include ::Timeout

    Defaults = { 
      :refresh_interval_dt => 3
    }

    # dmx_node_url: http://<gom server>/<dmx node path>
    #
    def initialize dmx_node_url, options = {}
      @options = (Defaults.merge options)
      @session = GomSession.new dmx_node_url
    end

    def run
      puts " -- running gom enttec daemon loop..."
      #grcs = Gom::Remote::CallbackServer.new
      #grcs.start
      loop do
        tic
        sleep @options[:refresh_interval_dt]
      end
    ensure
      #grcs.stop
    end

    private

    def tic
      puts " -- tic"
    rescue => e
      puts " ## #{e}"
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
