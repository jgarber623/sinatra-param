require 'active_support/core_ext/object/blank'
require 'sinatra/base'

require 'sinatra/param/version'
require 'sinatra/param/error'
require 'sinatra/param/type_convertor'
require 'sinatra/param/validator'

require 'sinatra/param/type_convertors/array_type_convertor'
require 'sinatra/param/type_convertors/float_type_convertor'
require 'sinatra/param/type_convertors/integer_type_convertor'
require 'sinatra/param/type_convertors/string_type_convertor'

require 'sinatra/param/validators/format_validator'
require 'sinatra/param/validators/required_validator'

module Sinatra
  module Param
    def param(name, type = :string, **options)
      validate_arguments(name, type)

      return unless params.include?(name) || options[:default] || options[:required]

      params[name] = apply_default(params[name], options[:default])
      params[name] = convertor_for_type(type).convert(params[name], options)

      validators_for_param(options).each { |validator| validator.validate(name, params[name], type, options) }
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

    def convertor_for_type(type)
      TypeConvertor.subclasses.find { |convertor| convertor::IDENTIFIER == type }
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
      raise ArgumentError, "type must be one of #{TypeConvertor.supported_types} (given :#{type})" unless TypeConvertor.supported_types.include?(type)
    end

    def validators_for_param(options)
      Validator.subclasses.find_all { |validator| options.key?(validator::IDENTIFIER) }
    end
  end

  helpers Param
end
