module Sinatra
  module Param
    class IntegerCoercion < Coercion
      class << self
        def apply(value, **_options)
          return value if value.is_a?(Integer)

          Integer(value, 10)
        rescue ::ArgumentError
          raise InvalidParameterError, %(Parameter value "#{value}" must be an Integer)
        end
      end
    end
  end
end
