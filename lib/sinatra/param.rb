require 'active_support/core_ext/object/blank'
require 'sinatra/param/core_ext/enumerable'

require 'sinatra/base'

require 'sinatra/param/version'
require 'sinatra/param/exceptions'
require 'sinatra/param/parameter'
require 'sinatra/param/registerable'

require 'sinatra/param/coercions'
require 'sinatra/param/coercions/array_coercion'
require 'sinatra/param/coercions/boolean_coercion'
require 'sinatra/param/coercions/float_coercion'
require 'sinatra/param/coercions/hash_coercion'
require 'sinatra/param/coercions/integer_coercion'
require 'sinatra/param/coercions/string_coercion'

require 'sinatra/param/validations'
require 'sinatra/param/validations/format_validation'
require 'sinatra/param/validations/in_validation'
require 'sinatra/param/validations/match_validation'
require 'sinatra/param/validations/max_validation'
require 'sinatra/param/validations/min_validation'
require 'sinatra/param/validations/required_validation'
require 'sinatra/param/validations/within_validation'

module Sinatra
  module Param
    module Helpers
      def param(name, type = :string, **options)
        return unless params.include?(name) || options[:default] || options[:required]

        params[name] = Parameter.new(name, type, params[name], options).apply
      rescue InvalidParameterError => exception
        handle_exception(exception, options)
      end

      def one_of(*names, **options)
        raise TooManyParametersError, "Only one of parameters [#{names.join(', ')}] is allowed" unless names.one? { |name| params[name].present? }
      rescue TooManyParametersError => exception
        handle_exception(exception, options)
      end

      def any_of(*names, **options)
        raise RequiredParameterError, "At least one of parameters [#{names.join(', ')}] is required" unless names.any? { |name| params[name].present? }
      rescue RequiredParameterError => exception
        handle_exception(exception, options)
      end

      def all_or_none_of(*names, **options)
        raise RequiredParameterError, "All or none of parameters [#{names.join(', ')}] are required" unless names.all_or_none? { |name| params[name].present? }
      rescue RequiredParameterError => exception
        handle_exception(exception, options)
      end

      private

      def handle_exception(exception, **options)
        message = options.fetch(:message, exception.message)

        raise exception.class, message if options[:raise] || settings.raise_sinatra_param_exceptions

        halt 400, content_type == mime_type(:json) ? { message: message }.to_json : message
      end
    end

    def self.registered(app)
      app.helpers Helpers

      app.set :raise_sinatra_param_exceptions, false unless app.respond_to?(:raise_sinatra_param_exceptions)
    end
  end
end
