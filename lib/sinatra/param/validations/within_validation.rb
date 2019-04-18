module Sinatra
  module Param
    module Validations
      class WithinValidation < BaseValidation
        Validations.register(:within, self)

        def initialize(*args)
          super

          raise ArgumentError, %(within must be a Range (given #{constraint.class})) unless constraint.is_a?(Range)
        end

        def apply
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be within #{constraint.min} and #{constraint.max}) unless constraint.include?(value)
        end

        private

        def constraint
          @constraint ||= options[:within]
        end
      end
    end
  end
end
