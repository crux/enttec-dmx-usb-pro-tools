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

        url = "#{@base_url}#{subscription.uri}"
        callback_url = "http://#{callback_ip}/gnp?#{subscription.entry_uri}"
        params = {
          :callback_url => callback_url,
          :accept       => 'application/json'
        }
        http_put(url, params) # {|req| req.content_type = 'application/json'}
      end

      def callback_ip
        return @callback_ip unless @callback_ip.nil?
        txt = (read "/gom/config/connection.txt")
        unless m = (txt.match /^client_ip:\s*(\d+\.\d+\.\d+\.\d)/) 
          raise "/gom/config/connection: No Client IP? '#{txt}'"
        end
        @callback_ip = m[1]
      end

      private

      def http_put(url, params, &request_modifier)
        uri = URI.parse url
        req = Net::HTTP::Put.new uri.path
        req.set_form_data(params)
        request_modifier && (request_modifier.call req)

        session = (Net::HTTP.new uri.host, uri.port)
        case res = session.start { |http| http.request req }
        when Net::HTTPSuccess, Net::HTTPRedirection
          # OK
        else
          res.error!
        end
      end

    end
  end
end
