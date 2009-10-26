module Gom
  module Remote
    class Entry
      include Gom::Remote
      def connection 
        Gom::Remote.connection
      end
    end
  end
end

