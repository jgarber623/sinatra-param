module Sinatra
  module Param
    module Validations
      class MaxlengthValidation < BaseValidation
        Validations.register(:maxlength, self)

        def initialize(*args)
          super

          raise ArgumentError, %(type must be one of [:array, :hash, :string] (given :#{type})) unless [:array, :hash, :string].include?(type)
          raise ArgumentError, %(maxlength must be an Integer (given #{constraint.class})) unless constraint.is_a?(Integer)
        end

        def apply
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" length must be at most #{constraint}) unless value.length <= constraint
        end

        private

        def constraint
          @constraint ||= options[:maxlength]
        end
      end
    end
  end
end
