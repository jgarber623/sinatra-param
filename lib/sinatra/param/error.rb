module Sinatra
  module Param
    class Error < StandardError; end

    class ArgumentError < Error; end

    class InvalidParameterError < Error; end

    class RequiredParameterError < Error; end

    class TooManyParametersError < Error; end
  end
end
