module Sinatra
  module Param
    class Coercion
      class << self
        def for_type(type)
          subclasses.find { |coercion| coercion::IDENTIFIER == type }
        end

        def supported_coercions
          @supported_coercions ||= subclasses.map { |subclass| subclass::IDENTIFIER }.sort
        end
      end
    end
  end
end
