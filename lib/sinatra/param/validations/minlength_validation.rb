module Sinatra
  module Param
    module Validations
      class MinlengthValidation < BaseValidation
        Validations.register(:minlength, self)

        def initialize(*args)
          super

          raise ArgumentError, %(type must be one of [:array, :hash, :string] (given :#{type})) unless [:array, :hash, :string].include?(type)
          raise ArgumentError, %(minlength must be an Integer (given #{constraint.class})) unless constraint.is_a?(Integer)
        end

        def apply
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" length must be at least #{constraint}) unless value.length >= constraint
        end

        private

        def constraint
          @constraint ||= options[:minlength]
        end
      end
    end
  end
end
