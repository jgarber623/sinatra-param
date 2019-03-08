module Sinatra
  module Param
    class RequiredValidation < Validation
      class << self
        def identifier
          @identifier ||= :required
        end

        def validate(name, value, _type, options)
          raise InvalidParameterError, %(Parameter #{name} is required and cannot be blank) if options[:required] && value.blank?
        end
      end
    end
  end
end
