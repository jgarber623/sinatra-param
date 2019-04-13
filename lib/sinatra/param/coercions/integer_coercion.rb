module Sinatra
  module Param
    class IntegerCoercion < Coercion
      class << self
        def apply(name, value, **_options)
          return value if value.is_a?(Integer)

          Integer(value, 10)
        rescue ::ArgumentError
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be an Integer)
        end
      end
    end
  end
end
