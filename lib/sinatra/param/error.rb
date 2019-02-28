module Sinatra
  module Param
    class InvalidParameterError < StandardError
      attr_accessor :param, :options
    end
  end
end
