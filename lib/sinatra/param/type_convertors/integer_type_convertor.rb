module Sinatra
  module Param
    class IntegerTypeConvertor < TypeConvertor
      IDENTIFIER = :integer

      def self.convert(value, **_options)
        return value if value.is_a?(Integer)

        Integer(value)
      rescue ::ArgumentError
        raise InvalidParameterError, %(Parameter value "#{value}" must be an Integer)
      end
    end
  end
end
