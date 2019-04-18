module Sinatra
  module Param
    module Coercions
      class FloatCoercion < BaseCoercion
        Coercions.register(:float, self)

        def apply
          return value if value.is_a?(Float)

          Float(value)
        rescue ::ArgumentError
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be a Float)
        end
      end
    end
  end
end
