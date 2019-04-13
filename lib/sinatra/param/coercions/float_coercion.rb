module Sinatra
  module Param
    class FloatCoercion < Coercion
      class << self
        def apply(name, value, **_options)
          return value if value.is_a?(Float)

          Float(value)
        rescue ::ArgumentError
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be a Float)
        end
      end
    end
  end
end
