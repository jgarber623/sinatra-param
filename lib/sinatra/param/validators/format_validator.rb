module Sinatra
  module Param
    class FormatValidator < Validator
      IDENTIFIER = :format

      def self.validate(name, value, type, options)
        format = options[:format]

        raise ArgumentError, %(type must be :string (given :#{type})) unless type == :string
        raise ArgumentError, %(format must be a Regexp (given #{format.class})) unless format.is_a?(Regexp)

        raise InvalidParameterError, %(Parameter value "#{value}" must match format #{format.source}) unless value.match?(format)
      end
    end
  end
end
