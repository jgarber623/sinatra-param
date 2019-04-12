module Sinatra
  module Param
    class ArrayCoercion < Coercion
      class << self
        def apply(value, **options)
          return value if value.is_a?(Array)

          value.split(options.fetch(:delimiter, ','))
        end
      end
    end
  end
end
