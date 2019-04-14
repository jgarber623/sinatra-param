module Sinatra
  module Param
    class Coercion
      class << self
        def for(identifier)
          subclasses.find { |subclass| subclass.identifier == identifier }
        end

        def identifier
          @identifier ||= name.demodulize.underscore.gsub('_coercion', '').to_sym
        end

        def supported_coercions
          @supported_coercions ||= subclasses.map(&:identifier).sort
        end
      end
    end
  end
end
