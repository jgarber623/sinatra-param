module Sinatra
  module Param
    class TypeConvertor
      class << self
        def inherited(base)
          subclasses << base

          super(base)
        end

        def subclasses
          @subclasses ||= []
        end

        def supported_types
          @supported_types ||= subclasses.map { |subclass| subclass::IDENTIFIER }.sort
        end
      end
    end
  end
end
