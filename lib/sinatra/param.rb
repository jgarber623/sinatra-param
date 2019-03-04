require 'sinatra/base'

require 'sinatra/param/version'
require 'sinatra/param/error'
require 'sinatra/param/support'

module Sinatra
  module Param
    include Support

    Boolean = :boolean

    def param(name, type, options = {})
      name = name.to_s

      return unless params.member?(name) || options.key?(:default) || options[:required]

      begin
        params[name] = coerce(params[name], type, options)
        params[name] = (options[:default].call if options[:default].respond_to?(:call)) || options[:default] if params[name].nil? && options.key?(:default)
        params[name] = options[:transform].to_proc.call(params[name]) if params[name] && options[:transform]

        validate!(params[name], options)

        params[name]
      rescue InvalidParameterError => exception
        if options[:raise] || (settings.raise_sinatra_param_exceptions rescue false)
          exception.param = name
          exception.options = options

          raise exception
        end

        error = options[:message] || exception.to_s

        if content_type&.match(mime_type(:json))
          error = { message: error, errors: { name => exception.message } }.to_json
        else
          content_type 'text/plain'
        end

        halt 400, error
      end
    end

    def one_of(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      names = args.collect(&:to_s)

      return unless names.length >= 2

      begin
        validate_one_of!(params, names)
      rescue InvalidParameterError => exception
        if options[:raise] || (settings.raise_sinatra_param_exceptions rescue false)
          exception.param = names
          exception.options = options

          raise exception
        end

        error = "Invalid parameters [#{names.join(', ')}]"
        error = { message: error, errors: { names => exception.message } }.to_json if content_type&.match(mime_type(:json))

        halt 400, error
      end
    end

    def any_of(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      names = args.collect(&:to_s)

      return unless names.length >= 2

      begin
        validate_any_of!(params, names)
      rescue InvalidParameterError => exception
        if options[:raise] || (settings.raise_sinatra_param_exceptions rescue false)
          exception.param = names
          exception.options = options

          raise exception
        end

        error = "Invalid parameters [#{names.join(', ')}]"
        error = { message: error, errors: { names => exception.message } }.to_json if content_type&.match(mime_type(:json))

        halt 400, error
      end
    end

    private

    def coerce(param, type, options = {})
      return nil if param.nil?

      return param if (param.is_a?(type) rescue false)
      return Integer(param) if type == Integer
      return Float(param) if type == Float
      return String(param) if type == String
      return Date.parse(param) if type == Date
      return Time.parse(param) if type == Time
      return DateTime.parse(param) if type == DateTime
      return Array(param.split(options.fetch(:delimiter, ','))) if type == Array
      return Hash[param.split(options.fetch(:delimiter, ',')).map { |c| c.split(options.fetch(:separator, ':')) }] if type == Hash

      if [TrueClass, FalseClass, Boolean].include?(type)
        return false if /(false|f|no|n|0)$/i.match?(param.to_s)
        return true if /(true|t|yes|y|1)$/i.match?(param.to_s)
      end

      nil
    rescue ArgumentError
      raise InvalidParameterError, "'#{param}' is not a valid #{type}"
    end

    def validate!(param, options)
      options.each do |key, value|
        case key
        when :required
          raise InvalidParameterError, 'Parameter is required' if value && param.nil?
        when :blank
          raise InvalidParameterError, 'Parameter cannot be blank' if !value &&
                                                                      case param
                                                                      when String
                                                                        !/\S/.match?(param)
                                                                      when Array, Hash
                                                                        param.empty?
                                                                      else
                                                                        param.nil?
                                                                      end
        when :format
          raise InvalidParameterError, 'Parameter must be a string if using the format validation' unless param.is_a?(String)
          raise InvalidParameterError, "Parameter must match format #{value}" unless param =~ value
        when :is
          raise InvalidParameterError, "Parameter must be #{value}" unless param === value
        when :in, :within, :range
          raise InvalidParameterError, "Parameter must be within #{value}" unless param.nil? ||
                                                                                  case value
                                                                                  when Range
                                                                                    value.include?(param)
                                                                                  else
                                                                                    Array(value).include?(param)
                                                                                  end
        when :min
          raise InvalidParameterError, "Parameter cannot be less than #{value}" unless param.nil? || value <= param
        when :max
          raise InvalidParameterError, "Parameter cannot be greater than #{value}" unless param.nil? || value >= param
        when :min_length
          raise InvalidParameterError, "Parameter cannot have length less than #{value}" unless param.nil? || value <= param.length
        when :max_length
          raise InvalidParameterError, "Parameter cannot have length greater than #{value}" unless param.nil? || value >= param.length
        end
      end
    end

    def validate_one_of!(params, names)
      raise InvalidParameterError, "Only one of [#{names.join(', ')}] is allowed" if names.count { |name| present?(params[name]) } > 1
    end

    def validate_any_of!(params, names)
      raise InvalidParameterError, "One of parameters [#{names.join(', ')}] is required" if names.count { |name| present?(params[name]) } < 1
    end
  end

  helpers Param
end
