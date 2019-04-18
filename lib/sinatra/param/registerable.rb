module Sinatra
  module Param
    module Registerable
      def register(identifier, klass)
        registered[identifier] = klass
      end

      def registered
        @registered ||= {}
      end
    end
  end
end
