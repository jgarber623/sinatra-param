module Sinatra
  module Param
    module Validations
      class InValidation < BaseValidation
        Validations.register(:in, self)

        def initialize(*args)
          super

          raise ArgumentError, %(in must be an Array (given #{constraint.class})) unless constraint.is_a?(Array)
        end

        def apply
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be in [#{constraint.join(', ')}]) unless constraint.include?(value)
        end

        private

        def constraint
          @constraint ||= options[:in]
        end
      end
    end
  end
end
