module Sinatra
  module Param
    class MaxValidation < Validation
      class << self
        def apply(name, value, type, options)
          input = options[:max]

          raise ArgumentError, %(type must be one of [:float, :integer] (given :#{type})) unless [:float, :integer].include?(type)
          raise ArgumentError, %(min must be a Float or an Integer (given #{input.class})) unless [Float, Integer].include?(input.class)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" may be at most #{input}) unless value <= input
        end
      end
    end
  end
end
