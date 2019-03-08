module Sinatra
  module Param
    class Coercion
      class << self
        def for_type(type)
          subclasses.find { |coercion| coercion.identifier == type }
        end

        def supported_coercions
          @supported_coercions ||= subclasses.map(&:identifier).sort
        end
      end
    end
  end
end
