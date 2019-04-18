module Sinatra
  module Param
    module Validations
      class MatchValidation < BaseValidation
        Validations.register(:match, self)

        def initialize(*args)
          super

          raise ArgumentError, %(match must be a#{'n' if [Array, Integer].include?(value.class)} #{value.class} (given #{constraint.class})) unless value.class == constraint.class
        end

        def apply
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must match #{constraint}) unless value == constraint
        end

        private

        def constraint
          @constraint ||= options[:match]
        end
      end
    end
  end
end
