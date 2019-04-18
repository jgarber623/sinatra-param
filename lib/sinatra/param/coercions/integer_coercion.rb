module Sinatra
  module Param
    module Coercions
      class IntegerCoercion < BaseCoercion
        Coercions.register(:integer, self)

        def apply
          return value if value.is_a?(Integer)

          Integer(value, 10)
        rescue ::ArgumentError
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be an Integer)
        end
      end
    end
  end
end
