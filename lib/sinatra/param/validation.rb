module Sinatra
  module Param
    class Validation
      class << self
        def for_options(required: nil, **options)
          validations = subclasses.find_all { |validation| options.key?(validation.identifier) }

          return validations unless required

          validations.unshift(subclasses.find { |subclass| subclass.identifier == :required })
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
