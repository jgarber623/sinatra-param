module Sinatra
  module Param
    module Validations
      class FormatValidation < BaseValidation
        Validations.register(:format, self)

        def initialize(*args)
          super

          raise ArgumentError, %(type must be :string (given :#{type})) unless type == :string
          raise ArgumentError, %(format must be a Regexp (given #{constraint.class})) unless constraint.is_a?(Regexp)
        end

        def apply
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must match format #{constraint.source}) unless value.match?(constraint)
        end

        private

        def constraint
          @constraint ||= options[:format]
        end
      end
    end
  end
end
