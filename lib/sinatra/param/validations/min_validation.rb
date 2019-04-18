module Sinatra
  module Param
    module Validations
      class MinValidation < BaseValidation
        Validations.register(:min, self)

        def initialize(*args)
          super

          raise ArgumentError, %(type must be one of [:float, :integer] (given :#{type})) unless [:float, :integer].include?(type)
          raise ArgumentError, %(min must be a Float or an Integer (given #{constraint.class})) unless [Float, Integer].include?(constraint.class)
        end

        def apply
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be at least #{constraint}) unless value >= constraint
        end

        private

        def constraint
          @constraint ||= options[:min]
        end
      end
    end
  end
end
