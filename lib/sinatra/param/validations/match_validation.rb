module Sinatra
  module Param
    class MatchValidation < Validation
      class << self
        def apply(name, value, _type, options)
          match = options[:match]

          match_class = match.class
          value_class = value.class

          raise ArgumentError, %(match must be a#{'n' if [Array, Integer].include?(value_class)} #{value_class} (given #{match_class})) unless match_class == value_class

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must match #{match}) unless match == value
        end
      end
    end
  end
end
