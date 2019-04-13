module Sinatra
  module Param
    class BooleanCoercion < Coercion
      class << self
        def apply(name, value, **_options)
          return value if [TrueClass, FalseClass].include?(value.class)

          return false if %w[false no 0].include?(value)
          return true if %w[true yes 1].include?(value)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be a Boolean)
        end
      end
    end
  end
end
