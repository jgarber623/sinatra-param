module Sinatra
  module Param
    class IntegerCoercion < Coercion
      class << self
        def coerce(value, **_options)
          return value if value.is_a?(Integer)

          Integer(value)
        rescue ::ArgumentError
          raise InvalidParameterError, %(Parameter value "#{value}" must be an Integer)
        end

        def identifier
          @identifier ||= :integer
        end
      end
    end
  end
end