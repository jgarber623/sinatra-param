module Sinatra
  module Param
    class StringTypeConvertor < TypeConvertor
      IDENTIFIER = :string

      def self.convert(value, **_options)
        return value if value.is_a?(String)

        value.to_s
      end
    end
  end
end
