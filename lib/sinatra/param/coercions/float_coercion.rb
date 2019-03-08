module Sinatra
  module Param
    class FloatCoercion < Coercion
      class << self
        def coerce(value, **_options)
          return value if value.is_a?(Float)

          Float(value)
        rescue ::ArgumentError
          raise InvalidParameterError, %(Parameter value "#{value}" must be a Float)
        end

        def identifier
          @identifier ||= :float
        end
      end
    end
  end
end
