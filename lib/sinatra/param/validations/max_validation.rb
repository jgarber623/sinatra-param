module Sinatra
  module Param
    class MaxValidation < Validation
      class << self
        def apply(name, value, type, options)
          max = options[:max]

          raise ArgumentError, %(type must be one of [:float, :integer] (given :#{type})) unless [:float, :integer].include?(type)
          raise ArgumentError, %(min must be a Float or an Integer (given #{max.class})) unless [Float, Integer].include?(max.class)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" may be at most #{max}) unless value <= max
        end
      end
    end
  end
end
