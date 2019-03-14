module Sinatra
  module Param
    class HashCoercion < Coercion
      class << self
        def coerce(value, **options)
          delimiter = options.fetch(:delimiter, ',')
          separator = options.fetch(:separator, ':')

          raise ArgumentError, 'delimiter and separator cannot be the same' if delimiter == separator
          raise InvalidParameterError, %(Parameter value "#{value}" must be a Hash) unless value.match?(/^.+#{separator}/)

          Hash[value.split(delimiter).reject(&:empty?).map { |el| el.split(separator) }]
        end

        def identifier
          @identifier ||= :hash
        end
      end
    end
  end
end
