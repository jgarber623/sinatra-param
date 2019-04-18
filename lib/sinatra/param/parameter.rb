module Sinatra
  module Param
    class Parameter
      attr_reader :name, :type, :value, :options

      def initialize(name, type = :string, value = nil, **options)
        raise ArgumentError, "name must be a Symbol (given #{name.class})" unless name.is_a?(Symbol)
        raise ArgumentError, "type must be a Symbol (given #{type.class})" unless type.is_a?(Symbol)
        raise ArgumentError, "type must be one of #{registered_coercions.keys} (given :#{type})" unless registered_coercions[type]

        @name = name
        @type = type
        @value = Default.apply(value, options[:default])
        @options = options
      end

      def apply
        coerce.transform.validate

        value
      end

      def coerce
        @value = registered_coercions[type].new(name, value, options).apply

        self
      end

      def transform
        @value = Transformation.apply(value, options[:transform])

        self
      end

      def validate
        validations.each { |validation| validation.new(name, type, value, options).apply }

        self
      end

      private

      def registered_coercions
        @registered_coercions ||= Coercions.registered
      end

      def registered_validations
        @registered_validations ||= Validations.registered
      end

      def validations
        @validations ||= registered_validations.slice(*options.keys).values
      end

      module Default
        def self.apply(value, default = nil)
          return value unless value.blank? && default

          default.call
        rescue NoMethodError
          default
        end
      end

      module Transformation
        def self.apply(value, transform = nil)
          return value unless transform

          raise ArgumentError, "transform must be a Proc or Symbol (given #{transform.class})" unless [Proc, Symbol].include?(transform.class)

          transform.to_proc.call(value)
        rescue ::NoMethodError
          raise ArgumentError, %(transform ":#{transform}" does not exist for value of type #{value.class})
        end
      end
    end
  end
end
