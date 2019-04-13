module Sinatra
  module Param
    class Transformation
      class << self
        def apply(value, transform: nil, **_options)
          return value unless transform

          raise ArgumentError, "transform must be a Proc or Symbol (given #{transform.class})" unless [Proc, Symbol].include?(transform.class)

          transform.to_proc.call(value)
        rescue NoMethodError
          raise ArgumentError, %(transform ":#{transform}" does not exist for value of type #{value.class})
        end
      end
    end
  end
end
