module Sinatra
  module Param
    class WithinValidation < Validation
      class << self
        def apply(name, value, _type, options)
          values = options[:within]

          raise ArgumentError, %(within must be a Range (given #{values.class})) unless values.is_a?(Range)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be within #{values.min} and #{values.max}) unless values.include?(value)
        end
      end
    end
  end
end
