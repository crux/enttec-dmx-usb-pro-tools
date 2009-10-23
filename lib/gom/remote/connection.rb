require 'open-uri'

module Gom
  module Remote
    class Connection
      attr_reader :base_url

      def initialize url
        @base_url = url
      end

      def read path
        open("#{@base_url}#{path}").read
      end
    end
  end
end
