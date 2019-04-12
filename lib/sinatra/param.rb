require 'active_support/core_ext/class/subclasses'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'
require 'sinatra/base'

require 'sinatra/param/version'
require 'sinatra/param/error'
require 'sinatra/param/coercion'
require 'sinatra/param/default'
require 'sinatra/param/parameter'
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
    def param(name, type = :string, **options)
      validate_arguments(name, type)

      return unless params.include?(name) || options[:default] || options[:required]

      params[name] = Parameter.new(name, params[name], type, options).coerce.transform.validate.value
    rescue InvalidParameterError => exception
      handle_exception(exception, options)
    end

    def one_of(*names, **options)
      raise TooManyParametersError, "Only one of parameters [#{names.join(', ')}] is allowed" if present_names_count(names, params) > 1
    rescue TooManyParametersError => exception
      handle_exception(exception, options)
    end

    def any_of(*names, **options)
      raise RequiredParameterError, "At least one of parameters [#{names.join(', ')}] is required" if present_names_count(names, params) < 1
    rescue RequiredParameterError => exception
      handle_exception(exception, options)
    end

    def all_or_none_of(*names, **options)
      raise RequiredParameterError, "All or none of parameters [#{names.join(', ')}] are required" unless [0, names.length].include?(present_names_count(names, params))
    rescue RequiredParameterError => exception
      handle_exception(exception, options)
    end

    private

    def handle_exception(exception, options)
      raise exception if raise_exception?(options)

      halt 400, response_body("#{exception.class.name.demodulize}: #{exception.message}")
    end

    def present_names_count(names, params)
      names.count { |name| params[name].present? }
    end

    def raise_exception?(options)
      options[:raise] || settings.raise_sinatra_param_exceptions
    rescue NoMethodError
      false
    end

    def response_body(message)
      return { message: message }.to_json if content_type == mime_type(:json)

      message
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
