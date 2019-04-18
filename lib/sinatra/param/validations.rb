module Sinatra
  module Param
    module Validations
      extend Registerable

      class BaseValidation
        attr_reader :name, :type, :value, :options

        def initialize(name, type, value, **options)
          @name = name
          @type = type
          @value = value
          @options = options
        end
      end
    end
  end
end
