module Sinatra
  module Param
    class MinValidation < Validation
      class << self
        def apply(name, value, type, options)
          input = options[:min]

          raise ArgumentError, %(type must be one of [:float, :integer] (given :#{type})) unless [:float, :integer].include?(type)
          raise ArgumentError, %(min must be a Float or an Integer (given #{input.class})) unless [Float, Integer].include?(input.class)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be at least #{input}) unless value >= input
        end
      end
    end
  end
end
