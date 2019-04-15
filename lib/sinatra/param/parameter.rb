module Sinatra
  module Param
    class Parameter
      attr_reader :name, :value, :type, :options

      def initialize(name, value, type, **options)
        @name = name
        @value = Default.apply(value, options)
        @type = type
        @options = options
      end

      def coerce
        @value = Coercion.for(type).apply(name, value, options)

        self
      end

      def transform
        @value = Transformation.apply(value, options)

        self
      end

      def validate
        validations.each { |identifier| Validation.for(identifier).apply(name, value, type, options) }

        self
      end

      private

      def validations
        @validations ||= options.keys.find_all { |option| Validation.supported_validations.include?(option) }
      end
    end
  end
end
