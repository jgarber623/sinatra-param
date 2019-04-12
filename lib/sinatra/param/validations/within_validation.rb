module Sinatra
  module Param
    class WithinValidation < Validation
      class << self
        def apply(_name, value, _type, options)
          values = options[:within]

          raise ArgumentError, %(within must be a Range (given #{values.class})) unless values.is_a?(Range)

          raise InvalidParameterError, %(Parameter value "#{value}" must be within #{values.min} and #{values.max}) unless values.include?(value)
        end
      end
    end
  end
end
