require 'open-uri'

module Gom
  module Remote

    class << self; attr_accessor :connection; end

    class Connection
      attr_reader :base_url

      # take apart the URL into GOM and node path part
      def self.init url
        u = URI.parse url
        re = %r|#{u.scheme}://#{u.host}(:#{u.port})?|
        gom_url = (re.match url).to_s
        path = (url.sub gom_url, '')

        [(self.new gom_url), path]
      end

      def initialize base_url
        @base_url = base_url
        Gom::Remote.connection = self

        @subscriptions = {}
      end

      def read path
        open("#{@base_url}#{path}").read
      end

      def refresh subscription 
        @subscriptions[subscription.entry_uri] = subscription

=begin
        OBSERVED_NODE = '/some/node'
        CALLBACK_URL  = 'http://my.server.com:1234/'

        url = URI.parse "#{@base_url}/gom/observer#{subscription.uri}"
        req = Net::HTTP::Put.new url.path
        req.set_form_data(
          'callback_url' => CALLBACK_URL, 'accept' => 'application/json', 
        )

        Net::HTTP.new(url.host, url.port).start do |http|   
            http.request(req)
        end
=end
      end

      def callback_ip
        return @callback_ip unless @callback_ip.nil?
        txt = (read "/gom/config/connection.txt")
        unless m = (txt.match /^client_ip:\s*(\d+\.\d+\.\d+\.\d)/) 
          raise "/gom/config/connection: No Client IP? '#{txt}'"
        end
        @callback_ip = m[1]
      end
    end
  end
end

__END__
        @uri = "/gom/observer#{@entry_uri.sub ':', '/'}"
      end

      def refresh

        OBSERVED_NODE = '/some/node'
        CALLBACK_URL  = 'http://my.server.com:1234/'

        url = URI.parse "http://gom.service/gom/observer#{OBSERVED_NODE}"
        req = Net::HTTP::Put.new @uri
        req.set_form_data(
          'callback_url' => CALLBACK_URL, 'accept' => 'application/json', 
        )

        :operations       => [:update],
        :condition_script => nil, 
        :uri_regexp       => nil,
        )

        Net::HTTP.new(url.host, url.port).start do |http|   
            http.request(req)
        end





        req = Net::HTTP::Post.new @uri
        req.content_type = 'application/json'
        s = (RestFs::Serializer.from_mime_type req.content_type)
        req.body = s.encode(entry, :container => {
          :name => op, :attributes => {"uri"=> entry.uri }
        })



        session = (Net::HTTP.new callback.host, callback.port)
        case res = session.start { |http| http.request req }
        when Net::HTTPSuccess, Net::HTTPRedirection
          # OK
        else
          #Log.error "failed notification: #{res}"
          res.error!
        end
      end
