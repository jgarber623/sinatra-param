module Sinatra
  module Param
    class WithinValidation < Validation
      class << self
        def apply(name, value, _type, options)
          input = options[:within]

          raise ArgumentError, %(within must be a Range (given #{input.class})) unless input.is_a?(Range)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be within #{input.min} and #{input.max}) unless input.include?(value)
        end
      end
    end
  end
end
