module Sinatra
  module Param
    class BooleanTypeConvertor < TypeConvertor
      IDENTIFIER = :boolean

      def self.convert(value, **_options)
        return value if [TrueClass, FalseClass].include?(value.class)

        return false if %w[false no 0].include?(value)
        return true if %w[true yes 1].include?(value)

        raise InvalidParameterError, %(Parameter value "#{value}" must be a Boolean)
      end
    end
  end
end
