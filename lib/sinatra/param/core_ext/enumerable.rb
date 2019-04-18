unless Enumerable.method_defined?(:all_or_none?)
  module Enumerable
    def all_or_none?(&block)
      return true if all?(&block) || none?(&block)

      false
    end
  end
end
