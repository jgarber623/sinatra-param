module Sinatra
  module Param
    class Validation
      class << self
        def identifier
          @identifier ||= name.demodulize.underscore.gsub('_validation', '').to_sym
        end

        def for_options(options)
          subclasses.find_all { |validation| options.key?(validation.identifier) }
        end

        def supported_validations
          @supported_validations ||= subclasses.map(&:identifier).sort
        end
      end
    end
  end
end
