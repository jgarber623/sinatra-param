module Sinatra
  module Param
    class HashCoercion < Coercion
      class << self
        def apply(value, delimiter: ',', separator: ':', **_options)
          raise ArgumentError, 'delimiter and separator cannot be the same' if delimiter == separator

          raise InvalidParameterError, %(Parameter value "#{value}" must be a Hash) unless value.match?(/^.+#{separator}/)

          Hash[mapped_values(value, delimiter, separator)]
        end

        private

        def mapped_values(value, delimiter, separator)
          value.split(delimiter).reject(&:empty?).map { |el| el.split(separator) }
        end
      end
    end
  end
end
