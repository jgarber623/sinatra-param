module Sinatra
  module Param
    class Default
      class << self
        def apply(value, default: nil, **_options)
          return value unless value.blank? && default

          default.call
        rescue NoMethodError
          default
        end
      end
    end
  end
end
