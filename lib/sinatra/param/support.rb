# Implement ActiveSupport's #blank? and #present? methods without patching Object

module Sinatra
  module Param
    module Support
      private

      def blank?(object)
        object.respond_to?(:empty?) ? object.empty? : !object
      end

      def present?(object)
        !blank?(object)
      end
    end
  end
end
