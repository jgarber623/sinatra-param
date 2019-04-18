module Sinatra
  module Param
    module Coercions
      class HashCoercion < BaseCoercion
        Coercions.register(:hash, self)

        def initialize(*args)
          super

          raise ArgumentError, 'delimiter and separator cannot be the same' if delimiter == separator
        end

        def apply
          raise InvalidParameterError, %(Parameter #{name} value "#{value}" must be a Hash) unless value.match?(/^.+#{separator}/)

          Hash[mapped_values]
        end

        private

        def delimiter
          @delimiter ||= options.fetch(:delimiter, ',')
        end

        def mapped_values
          value.split(delimiter).reject(&:empty?).map { |el| el.split(separator) }
        end

        def separator
          @separator ||= options.fetch(:separator, ':')
        end
      end
    end
  end
end
