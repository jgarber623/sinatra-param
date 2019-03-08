module Sinatra
  module Param
    class StringCoercion < Coercion
      IDENTIFIER = :string

      def self.coerce(value, **_options)
        return value if value.is_a?(String)

        value.to_s
      end
    end
  end
end
