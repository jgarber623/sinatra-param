module Sinatra
  module Param
    class ArrayCoercion < Coercion
      IDENTIFIER = :array

      def self.coerce(value, **options)
        return value if value.is_a?(Array)

        value.split(options.fetch(:delimiter, ','))
      end
    end
  end
end
