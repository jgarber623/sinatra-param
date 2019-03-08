module Sinatra
  module Param
    class FloatCoercion < Coercion
      IDENTIFIER = :float

      def self.coerce(value, **_options)
        return value if value.is_a?(Float)

        Float(value)
      rescue ::ArgumentError
        raise InvalidParameterError, %(Parameter value "#{value}" must be a Float)
      end
    end
  end
end
