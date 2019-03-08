module Sinatra
  module Param
    class Validation
      class << self
        def inherited(base)
          subclasses << base

          super(base)
        end

        def subclasses
          @subclasses ||= []
        end

        def supported_validations
          @supported_validations ||= subclasses.map { |validation| validation::IDENTIFIER }.sort
        end
      end
    end
  end
end
