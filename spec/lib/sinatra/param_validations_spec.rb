describe Sinatra::Param, :param do
  before do
    mock_app do
      helpers Sinatra::Param

      before do
        content_type :json
      end

      get '/format' do
        param :foo, :string, format: %r{^https?://}

        json params
      end

      get '/in' do
        param :foo, :string, in: %w[a b]

        json params
      end

      get '/in/invalid/in' do
        param :foo, :string, in: 'a', raise: true
      end

      get '/in/raise' do
        param :foo, :string, in: %w[a b], raise: true
      end

      get '/format/invalid/format' do
        param :foo, :string, format: 1, raise: true
      end

      get '/format/invalid/type' do
        param :foo, :integer, format: %r{^https?://}, raise: true
      end

      get '/format/raise' do
        param :foo, :string, format: %r{^https?://}, raise: true
      end

      get '/required' do
        param :foo, :string, required: true

        json params
      end

      get '/required/raise' do
        param :foo, :string, raise: true, required: true
      end
    end
  end

  context 'when parameter must be in an array' do
    let(:message) { 'Parameter value "bar" must be in [a, b]' }
    let(:full_message) { "InvalidParameterError: #{message}" }

    it 'raises an ArgumentError when in is not an Array' do
      expect { get '/in/invalid/in', foo: 'bar' }.to raise_error(Sinatra::Param::ArgumentError, 'in must be an Array (given String)')
    end

    it 'raises an InvalidParameterError' do
      expect { get '/in/raise', foo: 'bar' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end

    it 'halts with a 400 HTTP response and a JSON response body' do
      get '/in', foo: 'bar'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: full_message }.to_json)
    end

    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/in', foo: 'a'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: 'a' }.to_json)
    end
  end

  context 'when parameter must match a specific format' do
    let(:message) { 'Parameter value "bar" must match format ^https?://' }
    let(:full_message) { "InvalidParameterError: #{message}" }

    it 'raises an ArgumentError when type is not :string' do
      expect { get '/format/invalid/type', foo: 1 }.to raise_error(Sinatra::Param::ArgumentError, 'type must be :string (given :integer)')
    end

    it 'raises an ArgumentError when format is not a Regexp' do
      expect { get '/format/invalid/format', foo: 'bar' }.to raise_error(Sinatra::Param::ArgumentError, 'format must be a Regexp (given Integer)')
    end

    it 'raises an InvalidParameterError' do
      expect { get '/format/raise', foo: 'bar' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end

    it 'halts with a 400 HTTP response and a JSON response body' do
      get '/format', foo: 'bar'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: full_message }.to_json)
    end

    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/format', foo: 'https://example.com'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: 'https://example.com' }.to_json)
    end
  end

  context 'when parameter is required' do
    let(:message) { 'Parameter foo is required and cannot be blank' }
    let(:full_message) { "InvalidParameterError: #{message}" }

    it 'raises an InvalidParameterError' do
      expect { get '/required/raise' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end

    it 'halts with a 400 HTTP response and a JSON response body when parameter is nil' do
      get '/required'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: full_message }.to_json)
    end

    it 'halts with a 400 HTTP response and a JSON response body when parameter is blank' do
      get '/required', foo: ''

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: full_message }.to_json)
    end

    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/required', foo: 'bar'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: 'bar' }.to_json)
    end
  end
end
