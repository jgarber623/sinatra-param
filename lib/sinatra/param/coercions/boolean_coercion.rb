module Sinatra
  module Param
    module Coercions
      class BooleanCoercion < BaseCoercion
        Coercions.register(:boolean, self)

        def apply
          return value if [TrueClass, FalseClass].include?(value.class)

          return false if %w[false no 0].include?(value)
          return true if %w[true yes 1].include?(value)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be a Boolean)
        end
      end
    end
  end
end
