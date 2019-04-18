module Sinatra
  module Param
    module Coercions
      class ArrayCoercion < BaseCoercion
        Coercions.register(:array, self)

        def apply
          return value if value.is_a?(Array)

          value.split(options.fetch(:delimiter, ','))
        end
      end
    end
  end
end
