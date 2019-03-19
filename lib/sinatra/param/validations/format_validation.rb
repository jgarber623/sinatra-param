module Sinatra
  module Param
    class FormatValidation < Validation
      class << self
        def apply(_name, value, type, options)
          format = options[:format]

          raise ArgumentError, %(type must be :string (given :#{type})) unless type == :string
          raise ArgumentError, %(format must be a Regexp (given #{format.class})) unless format.is_a?(Regexp)

          raise InvalidParameterError, %(Parameter value "#{value}" must match format #{format.source}) unless value.match?(format)
        end

        def identifier
          @identifier ||= :format
        end
      end
    end
  end
end
