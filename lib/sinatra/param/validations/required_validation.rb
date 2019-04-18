module Sinatra
  module Param
    module Validations
      class RequiredValidation < BaseValidation
        Validations.register(:required, self)

        def apply
          raise InvalidParameterError, %(Parameter #{name} is required and cannot be blank) if constraint && value.blank?
        end

        private

        def constraint
          @constraint ||= options[:required]
        end
      end
    end
  end
end
