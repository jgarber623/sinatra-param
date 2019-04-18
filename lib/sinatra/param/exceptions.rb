module Sinatra
  module Param
    class ArgumentError < StandardError; end

    class InvalidParameterError < StandardError; end

    class RequiredParameterError < StandardError; end

    class TooManyParametersError < StandardError; end
  end
end
