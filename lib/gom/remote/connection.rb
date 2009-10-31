require 'open-uri'
require 'json'

module Gom
  module Remote

    class << self; attr_accessor :connection; end

    class Connection

      attr_reader :base_url

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
        url = "#{@base_url}#{path}"
        open(url).read
      rescue Timeout::Error => e
        raise "connection timeout: #{url}"
      rescue => e
        puts " ## read error: #{url} -- #{e}"
        throw e
      end

      def refresh
        puts " -- refresh subscriptions(#{@subscriptions.size}):"
        @subscriptions.each do |sub| 
          puts "     - #{sub.name}"
          params = { "attributes[accept]" => 'application/json' }

          query = "/gnp;#{sub.name};#{sub.entry_uri}"
          params["attributes[callback_url]"] = "#{callback_server_base}#{query}"

          [:operations, :uri_regexp, :condition_script].each do |key|
            (v = sub.send key) and params["attributes[#{key}]"] = v
          end

          url = "#{@base_url}#{sub.uri}"
          http_put(url, params) # {|req| req.content_type = 'application/json'}
        end
      end

      def subscribe sub
        @subscriptions.delete sub # every sub only once!
        @subscriptions.push sub
      end

      def callback_server
        #@callback_server or (raise 'no callback server running!')
        @callback_server ||= start_callback_server
      end

      def callback_ip
        debugger if (defined? debugger)
        txt = (read "/gom/config/connection.txt")
        unless m = (txt.match /^client_ip:\s*(\d+\.\d+\.\d+\.\d+)/) 
          raise "/gom/config/connection: No Client IP? '#{txt}'"
        end
        @callback_ip = m[1]
      end

      private

      def gnp_callback name, entry_uri, req
        unless sub = @subscriptions.find { |s| s.name == name }
          raise "no such subscription: #{name} :: #{entry_uri}"#\n#{@subscriptions.inspect}"
        end
        op, payload = (decode_gnp_body req.body.read)
        begin
          (sub.callback.call op, payload)
        rescue => e
          callstack = "#{e.backtrace.join "\n    "}"
          puts " ## Subscription::callback - #{e}\n -> #{callstack}"
        end 
      end

      def decode_gnp_body txt
        debugger if (defined? debugger)
        json = (JSON.parse txt)
        puts " -- json GNP: #{json.inspect}"

        payload = nil
        op = %w{update delete create}.find { |op| json[op] }
        %w{attribute node}.find { |t| payload = json[op][t] }
        #puts "payload: #{payload.inspect}"
        [op, payload]

        #op = (json.include? 'update') ? :udpate : nil
        #op ||= (json.include? 'delete') ? :delete : nil
        #op ||= (json.include? 'create') ? :create : nil
        #op or (raise "unknown GNP op: #{txt}") 

        #payload = json[op.to_s]
        #[op, (payload['attribute'] || payload['node'])]
      end

      def callback_server_base
        @callback_server_base = "http://#{callback_server.host}:#{callback_server.port}"
      end

      def start_callback_server
        unless @callback_server
          o = { :Host => callback_ip, :Port => @options[:callback_port] }
          @callback_server = CallbackServer.new(o) {|*args| gnp_callback *args}
        end
        @callback_server.start
      end

      # incapsulates the underlying net access
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
