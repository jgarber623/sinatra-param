module Sinatra
  module Param
    class Default
      class << self
        def apply(value, **options)
          default = options.fetch(:default, nil)

          return value unless value.blank? && default

          default.call
        rescue NoMethodError
          default
        end
      end
    end
  end
end
