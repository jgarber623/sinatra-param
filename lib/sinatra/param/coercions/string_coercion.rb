module Sinatra
  module Param
    class StringCoercion < Coercion
      class << self
        def apply(value, **_options)
          return value if value.is_a?(String)

          value.to_s
        end
      end
    end
  end
end
