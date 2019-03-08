module Sinatra
  module Param
    class StringCoercion < Coercion
      class << self
        def coerce(value, **_options)
          return value if value.is_a?(String)

          value.to_s
        end

        def identifier
          @identifier ||= :string
        end
      end
    end
  end
end
