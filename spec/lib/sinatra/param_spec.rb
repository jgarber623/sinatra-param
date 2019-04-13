describe Sinatra::Param, :param do
  before do
    mock_app do
      helpers Sinatra::Param

      before do
        content_type :json
      end

      get '/arguments/invalid_name' do
        param 'foo', :string
      end

      get '/arguments/invalid_type' do
        param :foo, 'string'
      end

      get '/arguments/unsupported_type' do
        param :foo, :bar
      end

      get '/custom_message/raise' do
        param :foo, :string, message: 'bar', raise: true, required: true
      end

      get '/mixed_validations/raise' do
        param :foo, format: %r{^https?://}, raise: true, required: true
      end

      get '/optional_parameter' do
        param :foo, :string

        json params
      end

      get '/required_parameter' do
        param :foo, :string, required: true

        json params
      end

      get '/required_parameter/default' do
        param :foo, :string, default: 'bar', required: true

        json params
      end

      get '/required_parameter/raise' do
        param :foo, :string, raise: true, required: true
      end
    end
  end

  context 'when name is not a Symbol' do
    it 'raises an ArgumentError' do
      message = 'name must be a Symbol (given String)'

      expect { get '/arguments/invalid_name' }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when type is not a Symbol' do
    it 'raises an ArgumentError' do
      message = 'type must be a Symbol (given String)'

      expect { get '/arguments/invalid_type' }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when type is not supported' do
    it 'raises an ArgumentError' do
      message = 'type must be one of [:array, :boolean, :float, :hash, :integer, :string] (given :bar)'

      expect { get '/arguments/unsupported_type' }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when optional parameter is not present' do
    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/optional_parameter', bar: 'biz'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ bar: 'biz' }.to_json)
    end
  end

  context 'when required parameter is not present' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo is required and cannot be blank'

      expect { get '/required_parameter/raise' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end

    it 'returns a 400 HTTP response code and a JSON response body' do
      get '/required_parameter'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: 'InvalidParameterError: Parameter foo is required and cannot be blank' }.to_json)
    end

    context 'when default is provided' do
      it 'returns a 200 HTTP response code and a JSON response body' do
        get '/required_parameter/default'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: 'bar' }.to_json)
      end
    end
  end

  context 'when required parameter is present' do
    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/required_parameter', foo: 'bar'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: 'bar' }.to_json)
    end
  end

  context 'when setting a custom exception message' do
    it 'returns the custom exception message' do
      message = 'bar'

      expect { get '/custom_message/raise' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when mixing validations' do
    it 'prefers the required validation' do
      message = 'Parameter foo is required and cannot be blank'

      expect { get '/mixed_validations/raise' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end
end
