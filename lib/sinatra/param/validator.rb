module Sinatra
  module Param
    class Validator
      class << self
        def inherited(base)
          subclasses << base

          super(base)
        end

        def subclasses
          @subclasses ||= []
        end

        def supported_validations
          @supported_validations ||= subclasses.map { |validator| validator::IDENTIFIER }.sort
        end
      end
    end
  end
end
