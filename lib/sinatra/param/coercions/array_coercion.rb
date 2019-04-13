module Sinatra
  module Param
    class ArrayCoercion < Coercion
      class << self
        def apply(_name, value, delimiter: ',', **_options)
          return value if value.is_a?(Array)

          value.split(delimiter)
        end
      end
    end
  end
end
