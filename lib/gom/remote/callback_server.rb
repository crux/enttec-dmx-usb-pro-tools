require 'rack'

module Gom
  module Remote
    class CallbackServer
      Defaults = {
        :Host => "0.0.0.0", :Port => 2719, 
      }
      def initialize options = {}
        @options = (Defaults.merge options)
        @rack_script = Proc.new { |env| (dispatch env) }
      end

      def start
        @server.nil? or (raise "already running!")
        @thread = Thread.new do
          puts " -- starting callback server"
          begin
            Rack::Handler::Mongrel.run(@rack_script, @options) do |server|
              puts "    mongrel up: #{server}"
              @server = server
            end
          rescue => e
            puts " ## oops: #{e}"
          end
        end
      end

      def stop
        @server.nil? and (raise "not running!")
        puts ' -- stopping callback server..'
        @server.stop
        @server = nil
        puts '    down.'
        sleep 2 # sleep added as a precaution
        puts ' -- killing callback thread now...'
        @thread.kill
        @thread = nil
        puts '    and gone.'
      end

      private

      def  env
        puts("-" * 80)
        puts env
        puts("-" * 80)
        req = Rack::Request.new(env)
        params = req.params
        [200, {"Content-Type"=>"text/plain"}, ["keep going dude!"]]
      end
    end
  end
end
