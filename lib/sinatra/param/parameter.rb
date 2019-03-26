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

      def coerce!
        @value = Coercion.for_type(type).apply(value, options)

        self
      end

      def transform!
        @value = Transformation.apply(value, options)

        self
      end

      def validate!
        validations.each { |validation| validation.apply(name, value, type, options) }
      end

      private

      def validations
        @validations ||= Validation.for_param(options)
      end
    end
  end
end
