module Sinatra
  module Param
    class ArrayTypeConvertor < TypeConvertor
      IDENTIFIER = :array

      def self.convert(value, **options)
        return value if value.is_a?(Array)

        value.split(options.fetch(:delimiter, ','))
      end
    end
  end
end
