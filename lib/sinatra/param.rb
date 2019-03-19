require 'active_support/core_ext/class/subclasses'
require 'active_support/core_ext/object/blank'
require 'sinatra/base'

require 'sinatra/param/version'
require 'sinatra/param/error'
require 'sinatra/param/coercion'
require 'sinatra/param/default'
require 'sinatra/param/transformation'
require 'sinatra/param/validation'

require 'sinatra/param/coercions/array_coercion'
require 'sinatra/param/coercions/boolean_coercion'
require 'sinatra/param/coercions/float_coercion'
require 'sinatra/param/coercions/hash_coercion'
require 'sinatra/param/coercions/integer_coercion'
require 'sinatra/param/coercions/string_coercion'

require 'sinatra/param/validations/in_validation'
require 'sinatra/param/validations/format_validation'
require 'sinatra/param/validations/max_validation'
require 'sinatra/param/validations/min_validation'
require 'sinatra/param/validations/required_validation'
require 'sinatra/param/validations/within_validation'

module Sinatra
  module Param
    # rubocop:disable Metrics/AbcSize
    def param(name, type = :string, **options)
      validate_arguments(name, type)

      return unless params.include?(name) || options[:default] || options[:required]

      params[name] = Default.apply(params[name], options)
      params[name] = Coercion.for_type(type).apply(params[name], options)
      params[name] = Transformation.apply(params[name], options)

      Validation.for_param(options).each { |validation| validation.apply(name, params[name], type, options) }
    rescue InvalidParameterError => exception
      handle_exception(exception, options)
    end
    # rubocop:enable Metrics/AbcSize

    def one_of(*names, **options)
      raise TooManyParametersError, "Only one of parameters [#{names.join(', ')}] is allowed" if names_count(names, params) > 1
    rescue TooManyParametersError => exception
      handle_exception(exception, options)
    end

    def any_of(*names, **options)
      raise RequiredParameterError, "At least one of parameters [#{names.join(', ')}] is required" if names_count(names, params) < 1
    rescue RequiredParameterError => exception
      handle_exception(exception, options)
    end

    private

    def handle_exception(exception, options)
      raise exception if raise_exception?(options)

      message = "#{exception.class.name.split('::').last}: #{exception.message}"

      response_body = message
      response_body = { message: message }.to_json if content_type&.match(mime_type(:json))

      halt 400, response_body
    end

    def names_count(names, params)
      names.count { |name| params[name].present? }
    end

    def raise_exception?(options)
      options[:raise] || (settings.raise_sinatra_param_exceptions if settings.respond_to?(:raise_sinatra_param_exceptions))
    end

    def validate_arguments(name, type)
      supported_coercions = Coercion.supported_coercions

      raise ArgumentError, "name must be a Symbol (given #{name.class})" unless name.is_a?(Symbol)
      raise ArgumentError, "type must be a Symbol (given #{type.class})" unless type.is_a?(Symbol)
      raise ArgumentError, "type must be one of #{supported_coercions} (given :#{type})" unless supported_coercions.include?(type)
    end
  end

  helpers Param
end
