require 'active_support/core_ext/object/blank'
require 'sinatra/base'

require 'sinatra/param/version'
require 'sinatra/param/error'
require 'sinatra/param/coercion'
require 'sinatra/param/validation'

require 'sinatra/param/coercions/array_coercion'
require 'sinatra/param/coercions/boolean_coercion'
require 'sinatra/param/coercions/float_coercion'
require 'sinatra/param/coercions/integer_coercion'
require 'sinatra/param/coercions/string_coercion'

require 'sinatra/param/validations/format_validation'
require 'sinatra/param/validations/required_validation'

module Sinatra
  module Param
    def param(name, type = :string, **options)
      validate_arguments(name, type)

      return unless params.include?(name) || options[:default] || options[:required]

      params[name] = apply_default(params[name], options[:default])
      params[name] = coercion_for_type(type).coerce(params[name], options)

      validations_for_param(options).each { |validation| validation.validate(name, params[name], type, options) }
    rescue InvalidParameterError => exception
      handle_exception(exception, options)
    end

    def one_of(*names, **options)
      raise TooManyParametersError, "Only one of parameters [#{names.join(', ')}] is allowed" if names.count { |name| params[name].present? } > 1
    rescue TooManyParametersError => exception
      handle_exception(exception, options)
    end

    def any_of(*names, **options)
      raise RequiredParameterError, "At least one of parameters [#{names.join(', ')}] is required" if names.count { |name| params[name].present? } < 1
    rescue RequiredParameterError => exception
      handle_exception(exception, options)
    end

    private

    def apply_default(value, default)
      return value unless value.blank? && default.present?

      default.respond_to?(:call) ? default.call : default
    end

    def coercion_for_type(type)
      Coercion.subclasses.find { |coercion| coercion::IDENTIFIER == type }
    end

    def handle_exception(exception, options)
      raise exception if options[:raise]

      message = "#{exception.class.name.split('::').last}: #{exception.message}"

      response_body = message
      response_body = { message: message }.to_json if content_type&.match(mime_type(:json))

      halt 400, response_body
    end

    def validate_arguments(name, type)
      raise ArgumentError, "name must be a Symbol (given #{name.class})" unless name.is_a?(Symbol)
      raise ArgumentError, "type must be a Symbol (given #{type.class})" unless type.is_a?(Symbol)
      raise ArgumentError, "type must be one of #{Coercion.supported_coercions} (given :#{type})" unless Coercion.supported_coercions.include?(type)
    end

    def validations_for_param(options)
      Validation.subclasses.find_all { |validation| options.key?(validation::IDENTIFIER) }
    end
  end

  helpers Param
end
