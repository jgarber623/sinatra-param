module Sinatra
  module Param
    class MaxValidation < Validation
      class << self
        def apply(_name, value, type, options)
          max = options[:max]

          raise ArgumentError, %(type must be one of [:float, :integer] (given :#{type})) unless [:float, :integer].include?(type)
          raise ArgumentError, %(min must be a Float or an Integer (given #{max.class})) unless [Float, Integer].include?(max.class)

          raise InvalidParameterError, %(Parameter value "#{value}" may be at most #{max}) unless value <= max
        end

        def identifier
          @identifier ||= :max
        end
      end
    end
  end
end
