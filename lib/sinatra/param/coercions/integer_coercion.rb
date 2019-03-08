module Sinatra
  module Param
    class IntegerCoercion < Coercion
      IDENTIFIER = :integer

      def self.coerce(value, **_options)
        return value if value.is_a?(Integer)

        Integer(value)
      rescue ::ArgumentError
        raise InvalidParameterError, %(Parameter value "#{value}" must be an Integer)
      end
    end
  end
end
