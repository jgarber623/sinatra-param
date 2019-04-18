module Sinatra
  module Param
    module Coercions
      extend Registerable

      class BaseCoercion
        attr_reader :name, :value, :options

        def initialize(name, value, **options)
          @name = name
          @value = value
          @options = options
        end
      end
    end
  end
end
