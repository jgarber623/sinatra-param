module Sinatra
  module Param
    class InValidation < Validation
      class << self
        def apply(name, value, _type, options)
          input = options[:in]

          raise ArgumentError, %(in must be an Array (given #{input.class})) unless input.is_a?(Array)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be in [#{input.join(', ')}]) unless input.include?(value)
        end
      end
    end
  end
end
