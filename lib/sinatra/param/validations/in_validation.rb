module Sinatra
  module Param
    class InValidation < Validation
      class << self
        def apply(_name, value, _type, options)
          values = options[:in]

          raise ArgumentError, %(in must be an Array (given #{values.class})) unless values.is_a?(Array)

          raise InvalidParameterError, %(Parameter value "#{value}" must be in [#{values.join(', ')}]) unless values.include?(value)
        end
      end
    end
  end
end
