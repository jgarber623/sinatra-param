module Sinatra
  module Param
    class Validation
      class << self
        def for(identifier)
          subclasses.find { |subclass| subclass.identifier == identifier }
        end

        def identifier
          @identifier ||= name.demodulize.underscore.gsub('_validation', '').to_sym
        end

        def supported_validations
          @supported_validations ||= subclasses.map(&:identifier).sort
        end
      end
    end
  end
end
