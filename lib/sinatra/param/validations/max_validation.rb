module Sinatra
  module Param
    module Validations
      class MaxValidation < BaseValidation
        Validations.register(:max, self)

        def initialize(*args)
          super

          raise ArgumentError, %(type must be one of [:float, :integer] (given :#{type})) unless [:float, :integer].include?(type)
          raise ArgumentError, %(max must be a Float or an Integer (given #{constraint.class})) unless [Float, Integer].include?(constraint.class)
        end

        def apply
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" may be at most #{constraint}) unless value <= constraint
        end

        private

        def constraint
          @constraint ||= options[:max]
        end
      end
    end
  end
end
