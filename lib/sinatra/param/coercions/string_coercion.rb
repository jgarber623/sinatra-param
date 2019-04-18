module Sinatra
  module Param
    module Coercions
      class StringCoercion < BaseCoercion
        Coercions.register(:string, self)

        def apply
          return value if value.is_a?(String)

          value.to_s
        end
      end
    end
  end
end
