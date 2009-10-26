require 'open-uri'
require 'json'

module Gom
  module Remote

    class << self; attr_accessor :connection; end

    class Connection

      attr_reader :base_url, :subscriptions

      Defaults = {
        :callback_port => 2719
      }

      # take apart the URL into GOM and node path part
      def self.init url
        u = URI.parse url
        re = %r|#{u.scheme}://#{u.host}(:#{u.port})?|
        gom_url = (re.match url).to_s
        path = (url.sub gom_url, '')

        [(self.new gom_url), path]
      end

      def initialize base_url, options = {}
        @options = (Defaults.merge options)
        @base_url = base_url
        Gom::Remote.connection = self

        @subscriptions = []
      end

      def read path
        open("#{@base_url}#{path}").read
      end

      def refresh_subscriptions
        puts " -- refresh observers(#{@subscriptions.size})"
        @subscriptions.each { |sub| refresh sub }
      end

      def refresh subscription
        params = { "attributes[accept]" => 'application/json' }

        query = "/gnp;#{subscription.name};#{subscription.entry_uri}"
        params["attributes[callback_url]"] = "#{callback_server_base}#{query}"
        
        [:operations, :uri_regexp, :condition_script].each do |key|
          (v = subscription.send key) and params["attributes[#{key}]"] = v
        end

        url = "#{@base_url}#{subscription.uri}"
        http_put(url, params) # {|req| req.content_type = 'application/json'}
      end

      def callback_server
        #@callback_server or (raise 'no callback server running!')
        @callback_server ||= start_callback_server
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

      def handle_gnp name, entry_uri, req
        sub = @subscriptions.find { |s| s.name == name }
        json = (JSON.parse req.body.read)
        puts "json: #{json.inspect}"
      end

      def callback_server_base
        @callback_server_base = "http://#{callback_server.host}:#{callback_server.port}"
      end

      def start_callback_server
        unless @callback_server
          o = { :Host => callback_ip, :Port => @options[:callback_port] }
          @callback_server = CallbackServer.new(o) {|*args| handle_gnp *args}
        end
        @callback_server.start
      end

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
