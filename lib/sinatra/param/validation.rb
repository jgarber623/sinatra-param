module Sinatra
  module Param
    class Validation
      class << self
        def for_param(options)
          subclasses.find_all { |validation| options.key?(validation::IDENTIFIER) }
        end

        def supported_validations
          @supported_validations ||= subclasses.map { |validation| validation::IDENTIFIER }.sort
        end
      end
    end
  end
end
