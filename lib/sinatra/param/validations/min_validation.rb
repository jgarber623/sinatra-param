module Sinatra
  module Param
    class MinValidation < Validation
      class << self
        def apply(name, value, type, options)
          min = options[:min]

          raise ArgumentError, %(type must be one of [:float, :integer] (given :#{type})) unless [:float, :integer].include?(type)
          raise ArgumentError, %(min must be a Float or an Integer (given #{min.class})) unless [Float, Integer].include?(min.class)

          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be at least #{min}) unless value >= min
        end
      end
    end
  end
end
