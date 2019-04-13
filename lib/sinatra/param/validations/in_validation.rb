module Sinatra
  module Param
    class InValidation < Validation
      class << self
        def apply(name, value, _type, options)
          values = options[:in]

          raise ArgumentError, %(in must be an Array (given #{values.class})) unless values.is_a?(Array)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be in [#{values.join(', ')}]) unless values.include?(value)
        end
      end
    end
  end
end
