module Sinatra
  module Param
    class MatchValidation < Validation
      class << self
        def apply(name, value, _type, options)
          input = options[:match]

          value_class = value.class
          input_class = input.class

          raise ArgumentError, %(match must be a#{'n' if [Array, Integer].include?(value_class)} #{value_class} (given #{input_class})) unless value_class == input_class

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must match #{input}) unless value == input
        end
      end
    end
  end
end
