module Sinatra
  module Param
    class Coercion
      class << self
        def inherited(base)
          subclasses << base

          super(base)
        end

        def subclasses
          @subclasses ||= []
        end

        def supported_coercions
          @supported_coercions ||= subclasses.map { |subclass| subclass::IDENTIFIER }.sort
        end
      end
    end
  end
end
