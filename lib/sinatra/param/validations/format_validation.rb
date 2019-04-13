module Sinatra
  module Param
    class FormatValidation < Validation
      class << self
        def apply(name, value, type, options)
          input = options[:format]

          raise ArgumentError, %(type must be :string (given :#{type})) unless type == :string
          raise ArgumentError, %(format must be a Regexp (given #{input.class})) unless input.is_a?(Regexp)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must match format #{input.source}) unless value.match?(input)
        end
      end
    end
  end
end
